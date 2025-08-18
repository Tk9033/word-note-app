class CreateStudySessions < ActiveRecord::Migration[7.2]
  def change
    create_table :study_sessions do |t|
      t.references :deck, null: false, foreign_key: { on_delete: :cascade }
      t.integer  :status,        null: false, default: 0
      t.integer  :current_index, null: false, default: 0
      t.integer  :card_order,    array: true, null: false, default: []
      t.timestamps
    end
    add_index :study_sessions, :status
    add_index :study_sessions, :current_index
  end
end
