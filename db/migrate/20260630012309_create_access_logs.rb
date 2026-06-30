class CreateAccessLogs < ActiveRecord::Migration[8.1]
  def change
    create_table :access_logs do |t|
      t.references :registration, null: false, foreign_key: true
      t.references :credential, null: false, foreign_key: true
      t.string :result, null: false, default: "denied"
      t.datetime :attempted_at, null: false

      t.timestamps
    end
  end
end
