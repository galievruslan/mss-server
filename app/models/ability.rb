class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    
    if user.role? :admin
      can :manage, :all
      can :exchange , :view
      can :settings , :view
      can :settings , :manage
    elsif user.role? :supervisor
      can :read, :all           
      can :manage, [TemplateRoute, TemplateRoutePoint]
      cannot :read, [User, Role]
    elsif user.role? :manager       
      can :read, :all
      can :manage, Order, :manager_id => user.manager_id 
      can :manage, OrderItem , :order => { :id => Manager.find(user.manager_id).order_ids}
      can :manage, Route, :manager_id => user.manager_id 
      can :manage, RoutePoint, :route => { :id => Manager.find(user.manager_id).route_ids}
      can :route , :current
      cannot :read, [User, Role]            
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
