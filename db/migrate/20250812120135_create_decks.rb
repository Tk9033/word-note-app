class CreateDecks < ActiveRecord::Migration[7.2]
  def change
    create_table :decks do |t|
      t.string :name, limit: 50, null: false

      t.timestamps null: false
    end

    add_index :decks, :name, unique: true
  end
end
