class Ability
  include CanCan::Ability

  def initialize(user)
    if user.admin?
      can :read, ActiveAdmin::Page, :name => "Dashboard"
      can :manage, User
      can :manage, Meal
    end

    if user.manager?
      can :read, ActiveAdmin::Page, :name => "Dashboard"
      can :manage, User
    end
  end

end