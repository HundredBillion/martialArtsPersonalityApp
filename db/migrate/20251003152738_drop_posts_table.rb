class DropPostsTable < ActiveRecord::Migration[8.0]
  def change
    drop_table :posts do |t|
      t.string "title"
      t.text "body"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end
  end
end
