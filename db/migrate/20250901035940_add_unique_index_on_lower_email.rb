class AddUniqueIndexOnLowerEmail < ActiveRecord::Migration[7.2]
  disable_ddl_transaction!

  def up
    remove_index :users, column: :email, if_exists: true

    # 既存データを正規化（小文字 + 前後空白除去）
    execute <<~SQL
      UPDATE users
      SET email = LOWER(TRIM(email))
      WHERE email IS NOT NULL;
    SQL

    # 大文字小文字を無視したユニーク制約
    add_index :users, "LOWER(email)", unique: true,
              name: "index_users_on_lower_email",
              algorithm: :concurrently
  end

  def down
    remove_index :users, name: "index_users_on_lower_email",
              algorithm: :concurrently, if_exists: true

    # 元に戻す用（必要なら）
    add_index :users, :email, unique: true, algorithm: :concurrently
  end
end
