class CreateStudySessions < ActiveRecord::Migration[7.2]
  def change
    create_table :study_sessions do |t|
      t.references :deck, null: false, foreign_key: { on_delete: :cascade }
      t.integer :status, null: false, default: 0

      # 将来的に必要になるかもしれない
      #t.datetime :started_at, null: false
      #t.datetime :completed_at

      t.timestamps null: false
    end

    add_index :study_sessions, :status
    #add_index :study_sessions, :started_at
  end
end
