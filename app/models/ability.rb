class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    
    if user.role? :admin
      can :manage, :all
      can :view, :exchange 
      can :view, :settings 
      can :view, :reports
      can :manage, :settings
      can :export_again, Order
    elsif user.role? :supervisor
      can :view, :reports
      can :read, :all           
      can :manage, [TemplateRoute, TemplateRoutePoint]      
      cannot :read, Message
      can :read, Message, :user_id => user.id      
      can :read, Message, :id => user.message_ids
      can :manage, Message, :user_id => user.id      
      cannot :read, [User, Role, Group]
      cannot :manage, MobileClient      
    elsif user.role? :manager       
      can :read, :all
      can :manage, Order, :manager_id => [user.manager_id,nil]
      can :manage, OrderItem , :order => { :id => Manager.find(user.manager_id).order_ids}
      can :create, OrderItem
      can :manage, AuditDocument, :manager_id => [user.manager_id, nil]
      can :manage, AuditDocumentItem , :audit_document => { :id => Manager.find(user.manager_id).audit_document_ids}
      can :create, AuditDocumentItem
      can :manage, Route, :manager_id => [user.manager_id, nil]
      can :manage, RoutePoint, :route => { :id => Manager.find(user.manager_id).route_ids}
      can :create, RoutePoint
      can :route , :current
      can :manage, RoutePointPhoto, :route_point => { :id => RoutePoint.where(id: Route.where(manager_id: user.manager_id).collect(&:id)).collect(&:id)}
      can :create, RoutePointPhoto
      cannot :read, Message
      can :read, Message, :id => user.message_ids
      cannot :read, [User, Role, Group] 
      cannot :export_again, Order
      cannot :destroy, Order
      cannot :destroy, AuditDocument
      cannot :manage, MobileClient
    end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
