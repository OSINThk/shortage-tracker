class CreateJoinTablePrivilegesRoles < ActiveRecord::Migration[6.0]
  def change
    create_join_table :privileges, :roles do |t|
      t.index [:privilege_id, :role_id]
      t.index [:role_id, :privilege_id]
    end
  end
end
