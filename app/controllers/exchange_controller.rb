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
        customer_db = Customer.find_by_external_key(customer_external_key)
        if !customer_db
          new_customer = Customer.create(name: customer_name, external_key: customer_external_key)
        else 
          if !customer_db.validity
            customer_db.validity = true            
          end
          customer_db.update_attributes(name: customer_name)        
        end
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
        shipping_address_db = ShippingAddress.find_by_external_key(shipping_address_external_key)
        if !shipping_address_db       
          new_shipping_address = ShippingAddress.create(name: shipping_address_name, external_key: shipping_address_external_key, address: shipping_address_address, customer_id: shipping_address_customer_id)
        else
          if !shipping_address_db.validity
            shipping_address_db.validity = true
          end
          shipping_address_db.update_attributes(name: shipping_address_name, address: shipping_address_address)
        end
      end   
    end
    
    if params[:managers]
      managers = xml.elements.to_a("//manager")
      managers.each do |manager| 
        manager_name = manager.elements['name'].text
        manager_external_key = manager.elements['external_key'].text
        manager_db = Manager.find_by_external_key(manager_external_key)   
        if !manager_db
          new_manager = Manager.create(name: manager_name, external_key: manager_external_key)
        else
          if !manager_db.validity
            manager_db.validity = true
          end
          manager_db.update_attributes(name: manager_name)
        end        
      end   
    end
    
    if params[:managers_shipping_addresses]
      manager_shipping_addresses = xml.elements.to_a("//manager_shipping_address")
      manager_shipping_addresses.each do |manager_shipping_address|
        manager_external_key = manager_shipping_address.elements['manager_external_key'].text
        shipping_address_external_key = manager_shipping_address.elements['shipping_address_external_key'].text
        manager_db = Manager.find_by_external_key(manager_external_key)
        shipping_address_db = ShippingAddress.find_by_external_key(shipping_address_external_key)
        manager_shipping_address_db = ManagerShippingAddress.find_by_manager_id_and_shipping_address_id(manager_db.id, shipping_address_db.id)
        if !manager_shipping_address_db
          manager_shipping_address = ManagerShippingAddress.create(manager: manager_db, shipping_address: shipping_address_db)          
        end        
      end   
    end
    
    if params[:unit_of_measures]
      unit_of_measures = xml.elements.to_a("//unit_of_measure")
      unit_of_measures.each do |unit_of_measure| 
        unit_of_measure_name = unit_of_measure.elements['name'].text
        unit_of_measure_external_key = unit_of_measure.elements['external_key'].text
        unit_of_measure_db = UnitOfMeasure.find_by_external_key(unit_of_measure_external_key)
        if !unit_of_measure_db
          new_unit_of_measure = UnitOfMeasure.create(name: unit_of_measure_name, external_key: unit_of_measure_external_key)
        else
          if !unit_of_measure_db.validity
            unit_of_measure_db.validity = true 
          end
          unit_of_measure_db.update_attributes(name: unit_of_measure_name)
        end          
      end   
    end
    
    if params[:price_lists]
      price_lists = xml.elements.to_a("//price_list")
      price_lists.each do |price_list| 
        price_list_name = price_list.elements['name'].text
        price_list_external_key = price_list.elements['external_key'].text
        price_list_db = PriceList.find_by_external_key(price_list_external_key)
        if !price_list_db
          new_price_list = PriceList.create(name: price_list_name, external_key: price_list_external_key)
        else
          if !price_list_db.validity
            price_list_db.validity = true 
          end
          price_list_db.update_attributes(name: price_list_name)
        end          
      end   
    end
    
    if params[:categories]
      categories = xml.elements.to_a("//category")
      categories.each do |category| 
        category_name = category.elements['name'].text
        category_external_key = category.elements['external_key'].text
        category_db = Category.find_by_external_key(category_external_key)
        
        if category.attributes['type'] =='root'          
          if !category_db             
            new_category = Category.create(name: category_name, external_key: category_external_key)
          else
            if !category_db.validity
              category_db.validity = true 
            end
            category_db.update_attributes(name: category_name, parent: nil)
          end 
              
        else
          category_parent_ext_key = category.elements['parent_category_external_key'].text
          category_parent = Category.find_by_external_key(category_parent_ext_key)
          if !category_db             
            new_category = Category.create(name: category_name, external_key: category_external_key, parent: category_parent)
          else
            if !category_db.validity
              category_db.validity = true 
            end
            category_db.update_attributes(name: category_name, parent: category_parent)
          end  
        end
      end   
    end
    
    if params[:products]
      products = xml.elements.to_a("//product")
      products.each do |product| 
        product_name = product.elements['name'].text
        product_external_key = product.elements['external_key'].text
        product_category_external_key = product.elements['category_external_key'].text
        product_category = Category.find_by_external_key(product_category_external_key)
        product_db = Product.find_by_external_key(product_external_key)
        if !product_db
          new_product = Product.create(name: product_name, external_key: product_external_key, category: product_category)
        else
          if !product_db.validity
            product_db.validity = true 
          end
          product_db.update_attributes(name: product_name, category: product_category)
        end          
      end   
    end
    
    if params[:product_unit_of_measures]
      product_unit_of_measures = xml.elements.to_a("//product_unit_of_measure")
      product_unit_of_measures.each do |product_unit_of_measure|        
        product_unit_of_measure.attributes['type'] =='base' ? base_product_unit_of_measure = true : base_product_unit_of_measure = false        
        product_unit_of_measure_product_external_key = product_unit_of_measure.elements['product_external_key'].text
        product_unit_of_measure_external_key = product_unit_of_measure.elements['unit_of_measure_external_key'].text
        product_unit_of_measure_count_in_base_unit = product_unit_of_measure.elements['count_in_base_unit'].text
        product = Product.find_by_external_key(product_unit_of_measure_product_external_key)
        unit_of_measure = UnitOfMeasure.find_by_external_key(product_unit_of_measure_external_key)
        product_unit_of_measure_db = ProductUnitOfMeasure.find_by_product_id_and_unit_of_measure_id(product.id, unit_of_measure.id)
        if !product_unit_of_measure_db
          new_product_unit_of_measure = ProductUnitOfMeasure.create(product: product, unit_of_measure: unit_of_measure, count_in_base_unit: product_unit_of_measure_count_in_base_unit, base: base_product_unit_of_measure)
        else
          product_unit_of_measure_db.update_attributes(count_in_base_unit: product_unit_of_measure_count_in_base_unit, base: base_product_unit_of_measure)
        end          
      end   
    end
    
    if params[:price_list_lines]
      price_list_lines = xml.elements.to_a("//price_list_line")
      price_list_lines.each do |price_list_line| 
        product_external_key = price_list_line.elements['product_external_key'].text
        price_list_external_key = price_list_line.elements['price_list_external_key'].text
        price = price_list_line.elements['price'].text
        product = Product.find_by_external_key(product_external_key)
        price_list = PriceList.find_by_external_key(price_list_external_key)
        price_list_line_db = PriceListLine.find_by_product_id_and_price_list_id(product.id, price_list.id)
        if !price_list_line_db
          new_price_list_line = PriceListLine.create(product: product, price_list: price_list, price: price)
        else          
          price_list_line_db.update_attributes(price: price)
        end          
      end   
    end    
          
    redirect_to exchange_path, notice: 'Handbook was successfully imported.' 
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
      data.warehouse_id(order.warehouse.id)
      data.warehouse_name(order.warehouse.name)
      data.warehouse_external_key(order.warehouse.external_key)
      data.price_list_id(order.price_list.id)
      data.price_list_name(order.price_list.name)
      data.price_list_external_key(order.price_list.external_key)
      data.order_items do
        order.order_items.each do |order_item|
          data.order_item do
            data.product_id(order_item.product.id)
            data.product_external_key(order_item.product.external_key)
            data.product_name(order_item.product.name)
            data.unit_of_measure_name(order_item.unit_of_measure.name)
            data.unit_of_measure_external_key(order_item.unit_of_measure.external_key)
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
