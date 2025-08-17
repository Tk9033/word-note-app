class CreateCards < ActiveRecord::Migration[7.2]
  def change
    create_table :cards do |t|
      t.references :deck, null: false, foreign_key: true
      t.text :question, null: false
      t.text :answer, null: false

      t.timestamps null: false
    end
  end

  
end
