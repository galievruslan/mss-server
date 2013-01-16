class ExchangeController < ApplicationController
  require 'rexml/document'
    
  def index    
  end
  
  def upload
    uploaded_file = params[:xml_file]
    data = uploaded_file.read if uploaded_file.respond_to? :read
    if request.post? and data
      parse_with_rexml( data )        
    else
      redirect_to :action => 'index'
    end
  end
  
  def parse_with_rexml( xml_data )
    xml = REXML::Document.new( xml_data )
    root = doc.root
    root.each_recursive{ |element| 
      logger.info "Element: #{element}" 
    }
    
    # Hash.from_xml(xml)["customer"].inject({}) do |result, elem| 
      # result[elem["name"]] = elem["value"] 
      # logger.info result 
    # end
    redirect_to :action => 'index'
  end
   
  def get_orders
    @not_exported_orders = get_not_exported_orders
    files = {}
    @not_exported_orders.each do |not_exported_order|
      current_date_time = Time.now.strftime("%m-%e-%y %H:%M")
      file_path = "#{Rails.root.to_s}/tmp/orders/#{current_date_time}_order_#{not_exported_order.id}_#{not_exported_order.date}.xml"
      file_name = generate_xml_file(file_path, not_exported_order)
      files[file_name] = file_path
      not_exported_order.update_attributes(exported_at: Time.now)      
    end
    download_zip_arhive(files)
  end
  
  def get_not_exported_orders    
    @not_exported_orders = Order.find_all_by_exported_at(nil)    
    return @not_exported_orders
  end
  
  def generate_xml_file(file_path, order)

    data = Builder::XmlMarkup.new( :target => out_data = "", :indent => 2 )
    data.instruct!
    data.order do
      data.id(order.id)
      data.date(order.date)
      data.customer_id(order.shipping_address.customer.id)
      data.customer_name(order.shipping_address.customer.name)
      data.customer_external_key(order.shipping_address.customer.external_key)
      data.shipping_address_id(order.shipping_address.id)
      data.shipping_address_external_key(order.shipping_address.external_key)
      data.shipping_address_name(order.shipping_address.name)
      data.manager_id(order.manager.id)
      data.manager_name(order.manager.name)
      data.manager_external_key(order.manager.external_key)
      data.order_items do
        order.order_items.each do |order_item|
          data.order_item do
            data.product_id(order_item.product.id)
            data.product_external_key(order_item.product.external_key)
            data.product_name(order_item.product.name)
            data.quantity(order_item.quantity)
          end
        end
      end 
    end
        
    f = File.new(file_path, 'w')
    f.print(out_data) 
    # file_path = f.path
    file_name = File.basename(f.path)
    f.close
    # h = {file_name => file_path}
    # h = Hash.new
    # h[file_name] = file_path
    return file_name   
    # send_data( out_data, :type => "text/xml", :filename => "order#{order.id}.xml" )
         
  end
  
  def download_zip_arhive(files)
    temp_arhive = Tempfile.new("orders.zip")
    
    Zip::ZipOutputStream.open(temp_arhive.path) do |z|
      files.each do |file_name,file_path|
        z.put_next_entry(file_name)
        z.print IO.read(file_path)
      end
    end
    send_file(temp_arhive.path, :type => 'application/zip', :disposition => 'attachment', :filename => "orders.zip", :stream => false)
        
  end
end
