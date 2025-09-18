class CreateSubmissions < ActiveRecord::Migration[8.0]
  def change
    create_table :submissions do |t|
      t.string :name
      t.string :email
      t.string :ip_address
      t.string :user_agent
      t.string :result_primary
      # Use plain :json for SQLite compatibility. Postgres can still read this column.
      t.json :result_payload
      t.datetime :completed_at

      t.timestamps
    end
  end
end
