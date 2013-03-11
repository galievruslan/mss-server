# encoding: UTF-8

@status1 = Status.create(name: 'Посетил')
@status2 = Status.create(name: 'Не посятил')
@status3 = Status.create(name: 'Учет')
@status4 = Status.create(name: 'Отказ')


@user_admin = User.create(username: 'admin', password: '423200', password_confirmation: '423200', email: 'galievruslan@gmail.com', language: 'RU')
@user_supervisor = User.create(username: 'supervisor', password: '423200', password_confirmation: '423200', email: 'supervisor@alkotorg.com', language: 'EN')
@user_manager = User.create(username: 'manager', password: '423200', password_confirmation: '423200', email: 'manager@alkotorg.com', language: 'EN')

@role_admin = Role.create(name: 'admin')
@role_supervisor = Role.create(name: 'supervisor')
@role_manager = Role.create(name: 'manager')

@user_admin.roles << @role_admin
@user_admin.save
@user_supervisor.roles << @role_supervisor
@user_supervisor.save
@user_manager.roles << @role_manager
@user_manager.save