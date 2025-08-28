class SorceryRememberMe < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :remember_me_token, :string unless column_exists?(:users, :remember_me_token)
    add_column :users, :remember_me_token_expires_at, :datetime unless column_exists?(:users, :remember_me_token_expires_at)
    add_index  :users, :remember_me_token unless index_exists?(:users, :remember_me_token)
  end
end
