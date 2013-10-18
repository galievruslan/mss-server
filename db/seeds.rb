  # encoding: UTF-8

@status1 = Status.create(name: 'Не посетил')
@status2 = Status.create(name: 'Посетил')
@status3 = Status.create(name: 'Учет')
@status4 = Status.create(name: 'Отказ')


@user_admin = User.create(username: 'admin', password: '423200', password_confirmation: '423200', email: 'galievruslan@gmail.com', language: 'RU')
@user_supervisor = User.create(username: 'supervisor', password: '423200', password_confirmation: '423200', email: 'supervisor@alkotorg.com', language: 'RU')
@user_manager = User.create(username: 'manager', password: '423200', password_confirmation: '423200', email: 'manager@alkotorg.com', language: 'RU')

@role_admin = Role.create(name: 'admin')
@role_supervisor = Role.create(name: 'supervisor')
@role_manager = Role.create(name: 'manager')

@user_admin.roles << @role_admin
@user_admin.save
@user_supervisor.roles << @role_supervisor
@user_supervisor.save
@user_manager.roles << @role_manager
@user_manager.save

@user_manager.locations.create(timestamp: '2013-10-17 11:00:00', latitude: 55.811314, longitude: 49.102508)
@user_manager.locations.create(timestamp: '2013-10-17 11:05:00', latitude: 55.801377, longitude: 49.102337)
@user_manager.locations.create(timestamp: '2013-10-17 11:10:00', latitude: 55.797904, longitude: 49.10165)
@user_manager.locations.create(timestamp: '2013-10-17 11:15:00', latitude: 55.787578, longitude: 49.114181)
@user_manager.locations.create(timestamp: '2013-10-17 11:20:00', latitude: 55.784682, longitude: 49.118988)
@user_manager.locations.create(timestamp: '2013-10-17 11:25:00', latitude: 55.773387, longitude: 49.103023)