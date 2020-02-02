class AdminPolicy < ApplicationPolicy
  def index?
    roles = get_roles(user)
    roles.include?('admin')
  end

  def show?
    roles = get_roles(user)
    roles.include?('admin')
  end

  def create?
    roles = get_roles(user)
    roles.include?('admin')
  end

  def new?
    roles = get_roles(user)
    roles.include?('admin')
  end

  def update?
    roles = get_roles(user)
    roles.include?('admin')
  end

  def edit?
    roles = get_roles(user)
    roles.include?('admin')
  end

  def destroy?
    roles = get_roles(user)
    roles.include?('admin')
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end

  private
    def get_roles(user)
      if user.nil?
        return []
      else
        return user.role.map { |role| role.name }
      end
    end
end
