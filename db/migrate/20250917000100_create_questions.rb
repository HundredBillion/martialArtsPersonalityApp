class CreateQuestions < ActiveRecord::Migration[8.0]
  def change
    create_table :questions do |t|
      t.text :text, null: false
      t.integer :personality, null: false, default: 0
      t.integer :position, null: false

      t.timestamps
    end
    add_index :questions, :personality
    add_index :questions, :position
  end
end
