class AddOrderFieldsToStudySessions < ActiveRecord::Migration[7.2]
  def change
    add_column :study_sessions, :card_order, :jsonb, null: false, default: []
    add_column :study_sessions, :current_index, :integer, null: false, default: 0
  end
end
