# encoding: UTF-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
@status1 = Status.create(name: 'Посетил')
@status2 = Status.create(name: 'Не посетил')
@status3 = Status.create(name: 'Учет')
@status4 = Status.create(name: 'Отказ')

@manager1 = Manager.create(name: 'Иванов И.А')
@manager2 = Manager.create(name: 'Петров А.П')

@customers= []
@customers[0] = Customer.create(name: 'ООО "Тимерхан"')
@customers[1] = Customer.create(name: 'ООО "Эдельвейс"')
@customers[2] = Customer.create(name: 'ООО "Пятерочка"')
@customers[3] = Customer.create(name: 'ООО "Реал"')
@customers[4] = Customer.create(name: 'ООО "Метро"')

@products = []
for i in 0..1000
  @products[i] = Product.create(name: "Водка #{i}")
end
 
@shipping_addresses= Array.new(5).map!{Array.new(5)} 
for i in 0..4  
    @name=@customers[i].name
  for j in 0..4
    @shipping_addresses[i][j]=ShippingAddress.create(name: "#{@name} №#{j}")
    @customers[i].shipping_addresses << @shipping_addresses[i][j]
    
  end
  @customers[i].save
end

@route1=Route.create(date: '2013-01-15', manager: @manager1)

@route1.route_points=RoutePoint.create([{shipping_address: @shipping_addresses[0][1], status: @status2}, {shipping_address: @shipping_addresses[1][2], status: @status2},{shipping_address: @shipping_addresses[1][0], status: @status2}])
@route2=Route.create(date: '2013-01-15', manager: @manager2)
@route2.route_points=RoutePoint.create([{shipping_address: @shipping_addresses[2][0], status: @status2}, {shipping_address: @shipping_addresses[3][1], status: @status2},{shipping_address: @shipping_addresses[3][2], status: @status2}])

@order1=Order.create(date: '2013-01-15', manager: @manager1, shipping_address: @shipping_addresses[1][0])
@order1.order_items=OrderItem.create([{product: @products[1], quantity:10},{product: @products[5], quantity:12},{product: @products[10], quantity:20}])
@order2=Order.create(date: '2013-01-15', manager: @manager2, shipping_address: @shipping_addresses[4][3])
@order2.order_items=OrderItem.create([{product: @products[1], quantity:10},{product: @products[5], quantity:12},{product: @products[10], quantity:20}])











  