class AddUserToDecks < ActiveRecord::Migration[7.2]
  def change
    add_reference :decks, :user, null: true, foreign_key: true
  end
end
