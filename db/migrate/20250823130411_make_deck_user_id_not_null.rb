class MakeDeckUserIdNotNull < ActiveRecord::Migration[7.2]
  def up
    change_column_null :decks, :user_id, false
  end
  def down
    change_column_null :decks, :user_id, true
  end
end
