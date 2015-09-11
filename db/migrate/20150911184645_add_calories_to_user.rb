class AddCaloriesToUser < ActiveRecord::Migration
  def change
    add_column :users, :calories, :integer, default: 1200
  end
end
