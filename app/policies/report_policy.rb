class ReportPolicy < ApplicationPolicy
  def index?
    !user.nil?
  end

  def show?
    true
  end

  def create?
    true
  end

  def new?
    create?
  end

  def update?
    true
  end

  def edit?
    update?
  end

  def destroy?
    roles = get_roles(user)
    roles.include?('admin') || record.user_id == user.id
  end

  class Scope < Scope
    def resolve
      roles = get_roles(user)
      if roles.include?('admin')
        scope.includes(product_detail: { product: :localization }).all
      else
        scope.includes(product_detail: { product: :localization }).where(user_id: user.id)
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

  private
    def get_roles(user)
      if user.nil?
        return []
      else
        return user.role.map { |role| role.name }
      end
    end

end
