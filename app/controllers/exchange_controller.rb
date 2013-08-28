class ExchangeController < ApplicationController
  require 'rexml/document'  
  require 'net/ftp'
  include ExchangeHelper
  def index
    authorize! :exchange , :view     
  end
  
  def upload
    uploaded_file = params[:xml_file]
    data = uploaded_file.read if uploaded_file.respond_to? :read
    if request.post? and data
      parse_with_rexml(data, false)        
    else
      redirect_to exchange_path, notice: t(:select_file)
    end
  end
  
  def upload_from_ftp    
    downloaded_file = "#{Rails.root.to_s}/tmp/handbook/handbook.xml"
    download_file_from_ftp('handbook.xml', downloaded_file)
    data = File.open(downloaded_file, 'r')
    parse_with_rexml(data, true)      
  end
  
  def parse_with_rexml(xml_data, from_ftp)
    
    if from_ftp
      customers_upload = true
      shipping_addresses_upload = true
      managers_upload = true
      warehouses_upload = true
      manager_shipping_addresses_upload = true
      unit_of_measures_upload = true
      price_lists_upload = true
      categories_upload = true
      products_upload = true
      product_unit_of_measures_upload = true
      product_prices_upload = true
    else
      customers_upload = params[:customers]
      shipping_addresses_upload = params[:shipping_addresses]
      managers_upload = params[:managers]
      warehouses_upload = params[:warehouses]
      manager_shipping_addresses_upload = params[:managers_shipping_addresses]
      unit_of_measures_upload = params[:unit_of_measures]
      price_lists_upload = params[:price_lists]
      categories_upload = params[:categories]
      products_upload = params[:products]
      product_unit_of_measures_upload = params[:product_unit_of_measures]
      product_prices_upload = params[:product_prices]
    end
    
    @errors = []
    xml = REXML::Document.new(xml_data)
    
    if customers_upload
      Customer.transaction do        
        begin
          customers = xml.elements.to_a("//customer")
          
          customers_external_keys = []
          customers.each do |customer| 
            customers_external_keys << customer.elements['external_key'].text
          end          
          customers_false = Customer.where("external_key NOT IN (?)", customers_external_keys)
          customers_false.each do |customer_false|
            if customer_false.validity
              customer_false.update_attributes(validity: false)
            end
          end
          
          customers.each do |customer| 
            customer_name = customer.elements['name'].text
            customer_external_key = customer.elements['external_key'].text
            customer_address = customer.elements['address'].text
            customer_db = Customer.find_by_external_key(customer_external_key)
            if !customer_db
              new_customer = Customer.create(name: customer_name, external_key: customer_external_key, address: customer_address)
            else 
              if !customer_db.validity
                customer_db.update_attributes(name: customer_name, address: customer_address, validity: true)            
              else
                customer_db.update_attributes(name: customer_name, address: customer_address)
              end        
            end
          end
          rescue ActiveRecord::StatementInvalid
        end         
      end  
    end
    if shipping_addresses_upload
      ShippingAddress.transaction do        
        begin
          shipping_addresses = xml.elements.to_a("//shipping_address")
          
          shipping_addresses_external_keys = []
          shipping_addresses.each do |shipping_address| 
            shipping_addresses_external_keys << shipping_address.elements['external_key'].text
          end          
          shipping_addresses_false = ShippingAddress.where("external_key NOT IN (?)", shipping_addresses_external_keys)
          shipping_addresses_false.each do |shipping_address_false|
            if shipping_address_false.validity
              shipping_address_false.update_attributes(validity: false)
            end
          end
          
          shipping_addresses.each do |shipping_address| 
            shipping_address_name = shipping_address.elements['name'].text
            shipping_address_external_key = shipping_address.elements['external_key'].text
            shipping_address_address = shipping_address.elements['address'].text
            shipping_address_customer_external_key = shipping_address.elements['customer_external_key'].text
            shipping_address_customer = Customer.find_by_external_key(shipping_address_customer_external_key)
            if !shipping_address_customer
              error = I18n.t('errors.not_found_customer', external_key: shipping_address_customer_external_key) 
              @errors << error
              next          
            end
            shipping_address_db = ShippingAddress.find_by_external_key(shipping_address_external_key)
            if !shipping_address_db       
              new_shipping_address = ShippingAddress.create(name: shipping_address_name, external_key: shipping_address_external_key, address: shipping_address_address, customer: shipping_address_customer)
            else
              if !shipping_address_db.validity
                shipping_address_db.update_attributes(validity: true, name: shipping_address_name, address: shipping_address_address)
              else
                shipping_address_db.update_attributes(name: shipping_address_name, address: shipping_address_address)
              end 
            end
          end
          rescue ActiveRecord::StatementInvalid
        end
      end   
    end
    
    if warehouses_upload
      Warehouse.transaction do        
        begin
          warehouses = xml.elements.to_a("//warehouse")
          
          warehouses_external_keys = []
          warehouses.each do |warehouse| 
            warehouses_external_keys << warehouse.elements['external_key'].text
          end          
          warehouses_false = Warehouse.where("external_key NOT IN (?)", warehouses_external_keys)
          warehouses_false.each do |warehouse_false|
            if warehouse_false.validity
              warehouse_false.update_attributes(validity: false)
            end
          end
          
          warehouses.each do |warehouse| 
            warehouse_name = warehouse.elements['name'].text
            warehouse_external_key = warehouse.elements['external_key'].text
            warehouse_address = warehouse.elements['address'].text
            warehouse_db = Warehouse.find_by_external_key(warehouse_external_key)   
            if !warehouse_db
              new_warehouse = Warehouse.create(name: warehouse_name, external_key: warehouse_external_key, address: warehouse_address)
            else
              if !warehouse_db.validity
                warehouse_db.update_attributes(validity: true, name: warehouse_name, address: warehouse_address)
              else
                warehouse_db.update_attributes(name: warehouse_name, address: warehouse_address)
              end
            end        
          end
          rescue ActiveRecord::StatementInvalid
        end
      end
    end
    
    if managers_upload
      Manager.transaction do        
        begin
          managers = xml.elements.to_a("//manager")
          
          managers_external_keys = []
          managers.each do |manager| 
            managers_external_keys << manager.elements['external_key'].text
          end          
          managers_false = Manager.where("external_key NOT IN (?)", managers_external_keys)
          managers_false.each do |manager_false|
            if manager_false.validity
              manager_false.update_attributes(validity: false)
            end
          end
          
          managers.each do |manager| 
            manager_name = manager.elements['name'].text
            manager_external_key = manager.elements['external_key'].text
            
            if manager.elements['default_warehouse']
              manager_default_warehouse_external_key = manager.elements['default_warehouse'].text
              default_warehouse_db = Warehouse.find_by_external_key(manager_default_warehouse_external_key)
            else
              default_warehouse_db = nil
            end
            
            manager_db = Manager.find_by_external_key(manager_external_key)   
            if !manager_db
              new_manager = Manager.create(name: manager_name, external_key: manager_external_key, default_warehouse: default_warehouse_db)
              new_manager = Manager.create(name: manager_name, external_key: manager_external_key, default_warehouse: default_warehouse_db)
            else
              if !manager_db.validity
                # manager_db.update_attributes(validity: true, name: manager_name, default_warehouse: default_warehouse_db)
                manager_db.update_attributes(validity: true, name: manager_name)
              else
                # manager_db.update_attributes(name: manager_name, default_warehouse: default_warehouse_db)
                manager_db.update_attributes(name: manager_name)
              end
            end        
          end
          rescue ActiveRecord::StatementInvalid
        end
      end
    end
    
    if manager_shipping_addresses_upload
      ManagerShippingAddress.transaction do
        begin
          manager_shipping_addresses = xml.elements.to_a("//manager_shipping_address")
          
          manager_shipping_addresses_true_ids = []
          manager_shipping_addresses.each do |manager_shipping_address|
            manager_external_key = manager_shipping_address.elements['manager_external_key'].text
            shipping_address_external_key = manager_shipping_address.elements['shipping_address_external_key'].text
            manager_id = Manager.find_by_external_key(manager_external_key).id
            shipping_address_id = ShippingAddress.find_by_external_key(shipping_address_external_key).id
            manager_shipping_addresses_true_ids << ManagerShippingAddress.find_by_manager_id_and_shipping_address_id(manager_id, shipping_address_id).id
          end          
          
          manager_shipping_addresses_false = ManagerShippingAddress.where("id NOT IN (?)", manager_shipping_addresses_true_ids)
          manager_shipping_addresses_false.each do |manager_shipping_address_false|
            if manager_shipping_address_false.validity
              manager_shipping_address_false.update_attributes(validity: false)
            end
          end
          
          manager_shipping_addresses.each do |manager_shipping_address|
            manager_external_key = manager_shipping_address.elements['manager_external_key'].text
            shipping_address_external_key = manager_shipping_address.elements['shipping_address_external_key'].text
            manager_db = Manager.find_by_external_key(manager_external_key)
            shipping_address_db = ShippingAddress.find_by_external_key(shipping_address_external_key)
            
            if !manager_db
              error = I18n.t('errors.not_found_manager', external_key: manager_external_key) 
              @errors << error
              next          
            end
            if !shipping_address_db
              error = I18n.t('errors.not_found_shipping_address', external_key: shipping_address_external_key) 
              @errors << error
              next          
            end        
            
            manager_shipping_address_db = ManagerShippingAddress.find_by_manager_id_and_shipping_address_id(manager_db.id, shipping_address_db.id)
            if !manager_shipping_address_db
              new_manager_shipping_address = ManagerShippingAddress.create(manager: manager_db, shipping_address: shipping_address_db)          
            else
              if !manager_shipping_address_db.validity
                manager_shipping_address_db.update_attributes(validity: true)
              end
            end        
          end
          rescue ActiveRecord::StatementInvalid
        end
      end
    end
    
    if unit_of_measures_upload
      UnitOfMeasure.transaction do
        begin
          unit_of_measures = xml.elements.to_a("//unit_of_measure")
          
          unit_of_measures_external_keys = []
          unit_of_measures.each do |unit_of_measure| 
            unit_of_measures_external_keys << unit_of_measure.elements['external_key'].text
          end          
          unit_of_measures_false = UnitOfMeasure.where("external_key NOT IN (?)", unit_of_measures_external_keys)
          unit_of_measures_false.each do |unit_of_measure_false|
            if unit_of_measure_false.validity
              unit_of_measure_false.update_attributes(validity: false)
            end
          end
          
          unit_of_measures.each do |unit_of_measure| 
            unit_of_measure_name = unit_of_measure.elements['name'].text
            unit_of_measure_external_key = unit_of_measure.elements['external_key'].text
            unit_of_measure_db = UnitOfMeasure.find_by_external_key(unit_of_measure_external_key)
            if !unit_of_measure_db
              new_unit_of_measure = UnitOfMeasure.create(name: unit_of_measure_name, external_key: unit_of_measure_external_key)
            else
              if !unit_of_measure_db.validity
                unit_of_measure_db.update_attributes(validity: true, name: unit_of_measure_name)
              else
                unit_of_measure_db.update_attributes(name: unit_of_measure_name)
              end
            end          
          end
          rescue ActiveRecord::StatementInvalid
        end
      end
    end
    
    if price_lists_upload
      PriceList.transaction do
        begin
          price_lists = xml.elements.to_a("//price_list")
          
          price_lists_external_keys = []
          price_lists.each do |price_list| 
            price_lists_external_keys << price_list.elements['external_key'].text
          end          
          price_lists_false = PriceList.where("external_key NOT IN (?)", price_lists_external_keys)
          price_lists_false.each do |price_list_false|
            if price_list_false.validity
              price_list_false.update_attributes(validity: false)
            end
          end
          
          price_lists.each do |price_list| 
            price_list_name = price_list.elements['name'].text
            price_list_external_key = price_list.elements['external_key'].text
            price_list_db = PriceList.find_by_external_key(price_list_external_key)
            if !price_list_db
              new_price_list = PriceList.create(name: price_list_name, external_key: price_list_external_key)
            else
              if !price_list_db.validity
                price_list_db.update_attributes(validity: true, name: price_list_name)
              else
                price_list_db.update_attributes(name: price_list_name)
              end
            end          
          end
          rescue ActiveRecord::StatementInvalid
        end
      end
    end
    
    if categories_upload
      Category.transaction do
        begin
          categories = xml.elements.to_a("//category")
          
          categories_external_keys = []
          categories.each do |category| 
            categories_external_keys << category.elements['external_key'].text
          end          
          categories_false = Category.where("external_key NOT IN (?)", categories_external_keys)
          categories_false.each do |category_false|
            if category_false.validity
              category_false.update_attributes(validity: false)
            end
          end
          
          categories.each do |category| 
            category_name = category.elements['name'].text
            category_external_key = category.elements['external_key'].text
            category_db = Category.find_by_external_key(category_external_key)  
            if category.attributes['type'] =='root'          
              if !category_db             
                new_category = Category.create(name: category_name, external_key: category_external_key)
              else
                if !category_db.validity
                  category_db.update_attributes(validity: true, name: category_name, parent: nil)
                else
                  category_db.update_attributes(name: category_name, parent: nil)
                end
              end 
                  
            else
              category_parent_ext_key = category.elements['parent_category_external_key'].text
              category_parent = Category.find_by_external_key(category_parent_ext_key)
              
              if !category_parent
                error = I18n.t('errors.not_found_category', external_key: category_parent_ext_key) 
                @errors << error
                next         
              end
              
              if !category_db             
                new_category = Category.create(name: category_name, external_key: category_external_key, parent: category_parent)
              else
                if !category_db.validity
                  category_db.update_attributes(validity: true, name: category_name, parent: category_parent)
                else
                  category_db.update_attributes(name: category_name, parent: category_parent)
                end
              end            
            end
          end
          rescue ActiveRecord::StatementInvalid
        end
      end
    end
    
    if products_upload
      Product.transaction do
        begin
          products = xml.elements.to_a("//product")
          
          products_external_keys = []
          products.each do |product| 
            products_external_keys << product.elements['external_key'].text
          end          
          products_false = Product.where("external_key NOT IN (?)", products_external_keys)
          products_false.each do |product_false|
            if product_false.validity
              product_false.update_attributes(validity: false)
            end
          end
          
          products.each do |product| 
            product_name = product.elements['name'].text
            product_external_key = product.elements['external_key'].text
            product_category_external_key = product.elements['category_external_key'].text
            product_category = Category.find_by_external_key(product_category_external_key)
            
            if !product_category
              error = I18n.t('errors.not_found_category', external_key: product_category_external_key) 
              @errors << error
              next          
            end
            
            product_db = Product.find_by_external_key(product_external_key)
            if !product_db
              new_product = Product.create(name: product_name, external_key: product_external_key, category: product_category)
            else
              if !product_db.validity
                product_db.update_attributes(validity: true, name: product_name, category: product_category)
              else
                product_db.update_attributes(name: product_name, category: product_category)
              end
            end          
          end  
          rescue ActiveRecord::StatementInvalid
        end 
      end
    end
    
    if product_unit_of_measures_upload
      ProductUnitOfMeasure.transaction do
        begin
          product_unit_of_measures = xml.elements.to_a("//product_unit_of_measure")
          
          product_unit_of_measures_true_ids = []
          product_unit_of_measures.each do |product_unit_of_measure|
            product_external_key = product_unit_of_measure.elements['product_external_key'].text
            unit_of_measure_external_key = product_unit_of_measure.elements['unit_of_measure_external_key'].text 
            product_id = Product.find_by_external_key(product_external_key).id
            unit_of_measure_id = UnitOfMeasure.find_by_external_key(unit_of_measure_external_key).id
            product_unit_of_measures_true_id = ProductUnitOfMeasure.find_by_product_id_and_unit_of_measure_id(product_id, unit_of_measure_id).id
            product_unit_of_measures_true_ids << product_unit_of_measures_true_id
          end
          product_unit_of_measures_false = ProductUnitOfMeasure.where("id NOT IN (?)", product_unit_of_measures_true_ids)
          product_unit_of_measures_false.each do |product_unit_of_measure_false|
            if product_unit_of_measure_false.validity
              product_unit_of_measure_false.update_attributes(validity: false)
            end
          end
          
          product_unit_of_measures.each do |product_unit_of_measure|        
            product_unit_of_measure.attributes['type'] =='base' ? base_product_unit_of_measure = true : base_product_unit_of_measure = false        
            product_unit_of_measure_product_external_key = product_unit_of_measure.elements['product_external_key'].text
            product_unit_of_measure_external_key = product_unit_of_measure.elements['unit_of_measure_external_key'].text
            product_unit_of_measure_count_in_base_unit = product_unit_of_measure.elements['count_in_base_unit'].text
            product = Product.find_by_external_key(product_unit_of_measure_product_external_key)
            
            if !product
              error = I18n.t('errors.not_found_product', external_key: product_unit_of_measure_product_external_key) 
              @errors << error
              next          
            end
            
            unit_of_measure = UnitOfMeasure.find_by_external_key(product_unit_of_measure_external_key)
            
            if !unit_of_measure
              error = I18n.t('errors.not_found_unit_of_measure', external_key: product_unit_of_measure_external_key) 
              @errors << error
              next          
            end
            
            product_unit_of_measure_db = ProductUnitOfMeasure.find_by_product_id_and_unit_of_measure_id(product.id, unit_of_measure.id)
            if !product_unit_of_measure_db
              new_product_unit_of_measure = ProductUnitOfMeasure.create(product: product, unit_of_measure: unit_of_measure, count_in_base_unit: product_unit_of_measure_count_in_base_unit, base: base_product_unit_of_measure)
            else
              if !product_unit_of_measure_db.validity
                product_unit_of_measure_db.update_attributes(validity: true, count_in_base_unit: product_unit_of_measure_count_in_base_unit, base: base_product_unit_of_measure)
              else
                product_unit_of_measure_db.update_attributes(count_in_base_unit: product_unit_of_measure_count_in_base_unit, base: base_product_unit_of_measure)
              end
            end          
          end 
          rescue ActiveRecord::StatementInvalid
        end
      end  
    end
    
    if product_prices_upload
      ProductPrice.transaction do
        begin
          product_prices = xml.elements.to_a("//product_price")
          
          product_prices_true_ids = []
          product_prices.each do |product_price|
            product_external_key = product_price.elements['product_external_key'].text
            price_list_external_key = product_price.elements['price_list_external_key'].text
            product_id = Product.find_by_external_key(product_external_key).id
            price_list_id = PriceList.find_by_external_key(price_list_external_key).id
            product_prices_true_id = ProductPrice.find_by_product_id_and_price_list_id(product_id, price_list_id).id
            product_prices_true_ids << product_prices_true_id
          end
          
          product_prices_false = ProductPrice.where("id NOT IN (?)", product_prices_true_ids)
          product_prices_false.each do |product_price_false|
            if product_price_false.validity
              product_price_false.update_attributes(validity: false)
            end
          end
          
          product_prices.each do |product_price| 
            product_external_key = product_price.elements['product_external_key'].text
            price_list_external_key = product_price.elements['price_list_external_key'].text
            price = product_price.elements['price'].text
            product = Product.find_by_external_key(product_external_key)
            
            if !product
              error = I18n.t('errors.not_found_product', external_key: product_external_key) 
              @errors << error
              next          
            end
            
            price_list = PriceList.find_by_external_key(price_list_external_key)
            
            if !price_list
              error = I18n.t('errors.not_found_price_list', external_key: price_list_external_key) 
              @errors << error
              next          
            end
            
            product_price_db = ProductPrice.find_by_product_id_and_price_list_id(product.id, price_list.id)
            if !product_price_db
              new_product_price = ProductPrice.create(product: product, price_list: price_list, price: price)
            else
              if !product_price_db.validity
                product_price_db.update_attributes(validity: true, price: price)
              else      
                product_price_db.update_attributes(price: price)
              end
            end          
          end
          rescue ActiveRecord::StatementInvalid
        end
      end
    end        
    if !from_ftp 
      if @errors.count == 0
        redirect_to exchange_path, notice: t(:handbook_imported)
      else
        render action: "index"       
      end
    end    
  end
   
  def download_zip
    @not_exported_orders = get_not_exported_orders    
    if @not_exported_orders.count > 0
      files = {}
      @not_exported_orders.each do |not_exported_order|
        filename = make_order_filename(not_exported_order)
        file_path = "#{Rails.root.to_s}/tmp/orders/#{filename}.xml"
        file_name = generate_xml_file(file_path, not_exported_order)
        files[file_name] = file_path 
      end
      send_zip_arhive(files)
      
      @not_exported_orders.each do |not_exported_order|
        not_exported_order.update_attributes(exported_at: Time.now) 
      end
    else
      redirect_to exchange_path, notice: t(:no_not_exported_orders)
    end    
  end
  
  def send_to_ftp_cron
    @not_exported_orders = get_not_exported_orders
    if @not_exported_orders.count > 0
      files = {}
      @not_exported_orders.each do |not_exported_order|
        filename = make_order_filename(not_exported_order)      
        file_path = "#{Rails.root.to_s}/tmp/orders/#{filename}.xml"
        file_name = generate_xml_file(file_path, not_exported_order)
        files[file_name] = file_path              
      end
      upload_files_to_ftp(files)
      
      @not_exported_orders.each do |not_exported_order|
        not_exported_order.update_attributes(exported_at: Time.now) 
      end      
    end
  end
  
  def send_to_ftp
    @not_exported_orders = get_not_exported_orders
    if @not_exported_orders.count > 0
      files = {}
      @not_exported_orders.each do |not_exported_order|        
        filename = make_order_filename(not_exported_order)
        file_path = "#{Rails.root.to_s}/tmp/orders/#{filename}.xml"
        file_name = generate_xml_file(file_path, not_exported_order)
        files[file_name] = file_path              
      end
      upload_files_to_ftp(files)
      
      @not_exported_orders.each do |not_exported_order|
        not_exported_order.update_attributes(exported_at: Time.now) 
      end
      
      redirect_to exchange_path, notice: t(:orders_sent_to_ftp, count: @not_exported_orders.count)
    else
      redirect_to exchange_path, notice: t(:no_not_exported_orders)
    end    
  end
  
  def get_not_exported_orders    
    @not_exported_orders = Order.find_all_by_exported_at_and_complete(nil, true)    
    return @not_exported_orders
  end
  
  def generate_xml_file(file_path, order)

    data = Builder::XmlMarkup.new( :target => out_data = "", :indent => 2 )
    data.instruct!
    data.order do
      data.id(order.id)
      data.date(order.date)
      data.shipping_date(order.shipping_date)
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
      data.comment(order.comment)
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
  
  def send_zip_arhive(files)
    temp_arhive = Tempfile.new("orders.zip")
    
    Zip::ZipOutputStream.open(temp_arhive.path) do |z|
      files.each do |file_name,file_path|
        z.put_next_entry(file_name)
        z.print IO.read(file_path)
      end
    end
    send_file(temp_arhive.path, :type => 'application/zip', :disposition => 'attachment', :filename => "orders.zip", :stream => false)           
  end
  
  def upload_files_to_ftp(files)
    files.each do |file_name,file_path|
      file = File.open(file_path, 'r')
      ftp_server = Settings.ftp_server
      ftp_user = Settings.ftp_user
      ftp_password = Settings.ftp_password
      ftp_directory = Settings.ftp_outbox_directory
      ftp = Net::FTP.new(ftp_server, ftp_user, ftp_password)
      ftp.chdir(ftp_directory)
      ftp.putbinaryfile(file, file_name)
      ftp.close
    end
  end
  
  def download_file_from_ftp(download_file, downloaded_file)
    ftp_server = Settings.ftp_server
    ftp_user = Settings.ftp_user
    ftp_password = Settings.ftp_password
    ftp_directory = Settings.ftp_inbox_directory
    ftp_mode = Setting.ftp_mode
    ftp = Net::FTP.new()
    ftp.passive = ftp_mode
    ftp.connect(ftp_server)
    ftp.login(ftp_user, ftp_password)
    files = ftp.chdir(ftp_directory)
    ftp.getbinaryfile(download_file, downloaded_file, 1024)
    ftp.close
  end 
end
