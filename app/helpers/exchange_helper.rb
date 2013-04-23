module ExchangeHelper
  def make_order_filename(order)
    order_filename_string = Settings.order_filename
    if order_filename_string.scan("%warehouse%")
      order_filename_string = order_filename_string.gsub("%warehouse%", order.warehouse.external_key)
    end
    if order_filename_string.scan("%customer%")
      order_filename_string = order_filename_string.gsub("%shipping_address%", order.shipping_address.customer.external_key)
    end
    if order_filename_string.scan("%manager%")
      order_filename_string = order_filename_string.gsub("%manager%", order.manager.external_key)
    end
    if order_filename_string.scan("%shipping_address%")
      order_filename_string = order_filename_string.gsub("%shipping_address%", order.shipping_address.external_key)
    end
    if order_filename_string.scan("%id%")
      order_filename_string = order_filename_string.gsub("%id%", order.id.to_s)
    end
    if order_filename_string.scan("%datetime%")
      current_date_time = Time.now.strftime("%d-%m-%y %H-%M-%S")
      order_filename_string = order_filename_string.gsub("%datetime%", current_date_time)
    end
    if order_filename_string.scan("%order_datetime%")
      order_datetime = order.date.strftime("%d-%m-%y %H-%M-%S")
      order_filename_string = order_filename_string.gsub("%order_datetime%", order_datetime)
    end
    return order_filename_string    
  end
end
