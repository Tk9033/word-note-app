class AddNameToUsers < ActiveRecord::Migration[7.2]
  def up
    add_column :users, :name, :string unless column_exists?(:users, :name)
  end

  def down
    remove_column :users, :name if column_exists?(:users, :name)
  end
end
