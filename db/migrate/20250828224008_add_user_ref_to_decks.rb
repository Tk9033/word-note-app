class AddUserRefToDecks < ActiveRecord::Migration[7.2]
  def change
    add_reference :decks, :user, null: false, foreign_key: true
  end
end
