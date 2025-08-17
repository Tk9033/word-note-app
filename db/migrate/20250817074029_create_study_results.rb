class CreateStudyResults < ActiveRecord::Migration[7.2]
  def change
    create_table :study_results do |t|
      t.references :study_session, null: false, foreign_key: { on_delete: :cascade }
      t.references :card,          null: false, foreign_key: { on_delete: :cascade }
      t.boolean :correct, null: false


      t.timestamps
    end


    add_index :study_results, [:study_session_id, :card_id], unique: true

  end
end
