class AddUserRefToDecks < ActiveRecord::Migration[7.2]
  def change
    unless column_exists?(:decks, :user_id)
      add_reference :decks, :user, null: false, foreign_key: true
    else
      unless foreign_key_exists?(:decks, :users)
        add_foreign_key :decks, :users
      end
      unless index_exists?(:decks, :user_id)
        add_index :decks, :user_id
      end
      change_column_null :decks, :user_id, false
    end
  end
end
