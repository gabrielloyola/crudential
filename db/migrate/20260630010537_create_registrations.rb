class CreateRegistrations < ActiveRecord::Migration[8.1]
  def change
    create_table :registrations do |t|
      t.references :event, null: false, foreign_key: true
      t.references :participant, null: false, foreign_key: true
      t.string :status, null: false, default: "pending"
      t.datetime :confirmed_at

      t.timestamps
    end

    add_index :registrations, [ :event_id, :participant_id ], unique: true
  end
end
