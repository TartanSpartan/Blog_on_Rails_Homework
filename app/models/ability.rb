# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)

    alias_action :create, :read, :update, :destroy, to: :crud

    user ||= User.new # Fresh user who will need to log in
    if user.is_admin?
      can :manage, :all # Manage means is_admin can do everything on ALL the models 
    end

    can :crud, USER, :id => user.id # Associate the user ID to the current ID

    
    can :crud, Post do |post|
      post.user == user 
    end

    can :crud, Comment do |comment|
      comment.user == user  || comment.post.user == user
    end

  end
end
