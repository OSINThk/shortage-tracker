class ReportPolicy < ApplicationPolicy
  def index?
    !user.nil?
  end

  def show?
    roles = get_roles(user)
    roles.include?('admin') || record.user_id == user.id
  end

  def create?
    !user.nil?
  end

  def new?
    create?
  end

  def update?
    roles = get_roles(user)
    roles.include?('admin') || record.user_id == user.id
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
        scope.includes(product_detail: :product).all
      else
        scope.includes(product_detail: :product).where(user_id: user.id)
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
