# frozen_string_literal: true
class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new # guest user (not logged in)

    if user.has_role? :sysadmin
      can :manage, :all

    elsif user.has_role? :superadmin
      can :manage, Article
      can :manage, TodoItem
      can :manage, User
      cannot :manage, User, roles: { name: 'sysadmin' }
      cannot :manage, User, roles: { name: 'superadmin' }

    elsif user.has_role? :admin
      can :manage, Article
      can :manage, TodoItem, user_id: user.id
      can :read, User

    else # members + visitors..(default sign_up role)
      can :read, Article
      can :manage, Article, user_id: user.id
      can :manage, TodoItem, user_id: user.id
      can :read, User
    end

  end
end