class AddManagerRoleToUser < ActiveRecord::Migration
  def change
    add_column :users, :manager, :boolean, :null => false, :default => false
  end
end
