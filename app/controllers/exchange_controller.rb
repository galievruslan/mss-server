class ExchangeController < ApplicationController
  require 'rexml/document'
    
  def index
    authorize! :exchange , :view     
  end
  
  def upload
    uploaded_file = params[:xml_file]
    data = uploaded_file.read if uploaded_file.respond_to? :read
    if request.post? and data
      parse_with_rexml(data)        
    else
      redirect_to :action => 'index'
    end
  end
  
  def parse_with_rexml(xml_data)
    xml = REXML::Document.new(xml_data)
    if params[:customers]
      customers = xml.elements.to_a("//customer")
      customers.each do |customer| 
        customer_name = customer.elements['name'].text
        customer_external_key = customer.elements['external_key'].text
        new_customer = Customer.create(name: customer_name, external_key: customer_external_key)
      end   
    end
    if params[:shipping_addresses]
      shipping_addresses = xml.elements.to_a("//shipping_address")
      shipping_addresses.each do |shipping_address| 
        shipping_address_name = shipping_address.elements['name'].text
        shipping_address_external_key = shipping_address.elements['external_key'].text
        shipping_address_address = shipping_address.elements['address'].text
        shipping_address_customer_external_key = shipping_address.elements['customer_external_key'].text
        shipping_address_customer_id = Customer.find_by_external_key(shipping_address_customer_external_key).id        
        new_shipping_address = ShippingAddress.create(name: shipping_address_name, external_key: shipping_address_external_key, address: shipping_address_address, customer_id: shipping_address_customer_id)
      end   
    end
    
    if params[:managers]
      managers = xml.elements.to_a("//manager")
      managers.each do |manager| 
        manager_name = manager.elements['name'].text
        manager_external_key = manager.elements['external_key'].text              
        new_manager = Manager.create(name: manager_name, external_key: manager_external_key)
      end   
    end
    
    if params[:products]
      products = xml.elements.to_a("//product")
      products.each do |product| 
        product_name = product.elements['name'].text
        product_external_key = product.elements['external_key'].text
        product_price = product.elements['price'].text               
        new_product = Product.create(name: product_name, external_key: product_external_key, price: product_price)
      end   
    end
          
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
