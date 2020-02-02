class PagesPolicy < Struct.new(:user, :pages)
  def admin?
    roles = get_roles(user)
    roles.include?('admin')
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
