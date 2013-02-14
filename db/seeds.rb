# encoding: UTF-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
@status1 = Status.create(name: 'visited')
@status2 = Status.create(name: 'not visited')
@status3 = Status.create(name: 'accounting')
@status4 = Status.create(name: 'refusal')

@unit_of_measure1 = UnitOfMeasure.create(name: 'шт', external_key: 'СВ343')
@unit_of_measure2 = UnitOfMeasure.create(name: 'упак', external_key: 'СВ353')

@manager1 = Manager.create(name: 'Иванов И.А', external_key: '00001')
@manager2 = Manager.create(name: 'Петров А.П', external_key: '00002')

@price_list1 = PriceList.create(name: 'Розничная', external_key: 'СВ001')
@price_list2 = PriceList.create(name: 'Оптовая', external_key: 'СВ002')

@warehouse1 = Warehouse.create(name: 'Оптовый склад №1', external_key: 'СВ001', address: 'Техническая, 21')
@warehouse2 = Warehouse.create(name: 'Оптовый склад №30', external_key: 'СВ002', address: 'Техническая, 21а')

@customers= []
@customers[0] = Customer.create(name: 'ООО "Тимерхан"', external_key: '10001')
@customers[1] = Customer.create(name: 'ООО "Эдельвейс"', external_key: '10002')
@customers[2] = Customer.create(name: 'ООО "Пятерочка"', external_key: '10003')
@customers[3] = Customer.create(name: 'ООО "Реал"', external_key: '10004')
@customers[4] = Customer.create(name: 'ООО "Метро"', external_key: '10005')

@category1 = Category.create(name: 'Водка', external_key: '10001')
@category2 = Category.create(name: 'Вино', external_key: '10002')
@category3 = Category.create(name: 'Коньяк', external_key: '10003')
@subcategory1 = Category.create(name: 'КЛВЗ', external_key: '10004')
@subcategory2 = Category.create(name: 'ЧЛВЗ', external_key: '10005')
@subcategory3 = Category.create(name: 'УСЗ', external_key: '10006')
@category1.childrens << @subcategory1
@category1.childrens << @subcategory2
@category1.childrens << @subcategory3
@category1.save


@products = []
for i in 0..1000
  @products[i] = Product.create(name: "Водка #{i}", external_key: "CB#{i}", category: @subcategory1)
  @products[i].product_unit_of_measures = ProductUnitOfMeasure.create([{unit_of_measure: @unit_of_measure1, count_in_base_unit: 1, base: true}, {unit_of_measure: @unit_of_measure2, count_in_base_unit: 12}])
  @products[i].price_list_lines = PriceListLine.create([{price_list: @price_list1, price: 100.50},{price_list: @price_list2, price: 80.52}]) 
end
 
@shipping_addresses = Array.new(5).map!{Array.new(5)} 
for i in 0..4  
    @name = @customers[i].name
  for j in 0..4
    @shipping_addresses[i][j] = ShippingAddress.create(name: "#{@name} №#{j}", address: "г. Казань ул. Восстания д.#{j}", external_key: "00#{i}#{j}")
    @customers[i].shipping_addresses << @shipping_addresses[i][j]
    
  end
  @customers[i].save
end

@route1 = Route.create(date: '2013-01-15', manager: @manager1)
@route1.route_points = RoutePoint.create([{shipping_address: @shipping_addresses[0][1], status: @status2}, {shipping_address: @shipping_addresses[1][2], status: @status2},{shipping_address: @shipping_addresses[1][0], status: @status2}])
@route2 = Route.create(date: '2013-01-15', manager: @manager2)
@route2.route_points = RoutePoint.create([{shipping_address: @shipping_addresses[2][0], status: @status2}, {shipping_address: @shipping_addresses[3][1], status: @status2},{shipping_address: @shipping_addresses[3][2], status: @status2}])

@route_template1 = TemplateRoute.create(manager: @manager1, day_of_week: 0)
@route_template1.template_route_points = TemplateRoutePoint.create([{shipping_address: @shipping_addresses[0][1]},{shipping_address: @shipping_addresses[1][1]}])
@route_template2 = TemplateRoute.create(manager: @manager1, day_of_week: 1)
@route_template2.template_route_points = TemplateRoutePoint.create([{shipping_address: @shipping_addresses[0][2]},{shipping_address: @shipping_addresses[1][2]}])
@route_template3 = TemplateRoute.create(manager: @manager1, day_of_week: 2)
@route_template3.template_route_points = TemplateRoutePoint.create([{shipping_address: @shipping_addresses[0][3]},{shipping_address: @shipping_addresses[1][3]}])
@route_template4 = TemplateRoute.create(manager: @manager1, day_of_week: 3)
@route_template4.template_route_points = TemplateRoutePoint.create([{shipping_address: @shipping_addresses[0][4]},{shipping_address: @shipping_addresses[1][4]}])
@route_template5 = TemplateRoute.create(manager: @manager1, day_of_week: 4)
@route_template5.template_route_points = TemplateRoutePoint.create([{shipping_address: @shipping_addresses[2][1]},{shipping_address: @shipping_addresses[3][1]}])
@route_template6 = TemplateRoute.create(manager: @manager1, day_of_week: 5)
@route_template6.template_route_points = TemplateRoutePoint.create([{shipping_address: @shipping_addresses[2][2]},{shipping_address: @shipping_addresses[3][2]}])
@route_template7 = TemplateRoute.create(manager: @manager1, day_of_week: 6)
@route_template7.template_route_points = TemplateRoutePoint.create([{shipping_address: @shipping_addresses[2][3]},{shipping_address: @shipping_addresses[3][3]}])

@order1 = Order.create(date: '2013-01-15', manager: @manager1, shipping_address: @shipping_addresses[1][0], warehouse: @warehouse1, price_list: @price_list1, comment: "Срочная заявка")
@order1.order_items = OrderItem.create([{product: @products[1], unit_of_measure: @unit_of_measure1, quantity:10},{product: @products[5], unit_of_measure: @unit_of_measure1, quantity:12},{product: @products[10], unit_of_measure: @unit_of_measure2, quantity:20}])
@order2 = Order.create(date: '2013-01-15', manager: @manager2, shipping_address: @shipping_addresses[4][3], warehouse: @warehouse2, price_list: @price_list2, comment: "Приложить документы с прошлой отгрузки")
@order2.order_items = OrderItem.create([{product: @products[1], unit_of_measure: @unit_of_measure1, quantity:10},{product: @products[5], unit_of_measure: @unit_of_measure1, quantity:12},{product: @products[10], unit_of_measure: @unit_of_measure2, quantity:20}])

@user_admin = User.create(username: 'admin', password: '423200', password_confirmation: '423200', email: 'galievruslan@gmail.com')
@user_supervisor = User.create(username: 'supervisor', password: '423200', password_confirmation: '423200', email: 'supervisor@alkotorg.com')
@user_manager = User.create(username: 'manager', password: '423200', password_confirmation: '423200', email: 'manager@alkotorg.com', manager_id:1)

@role_admin = Role.create(name: 'admin')
@role_supervisor = Role.create(name: 'supervisor')
@role_manager = Role.create(name: 'manager')

@user_admin.roles << @role_admin
@user_admin.save
@user_supervisor.roles << @role_supervisor
@user_supervisor.save
@user_manager.roles << @role_manager
@user_manager.save