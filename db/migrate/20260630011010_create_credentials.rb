class CreateCredentials < ActiveRecord::Migration[8.1]
  def change
    create_table :credentials do |t|
      t.references :registration, null: false, foreign_key: true, index: { unique: true }
      t.string :status, null: false, default: "active"
      t.datetime :issued_at, null: false
      t.datetime :expires_at, null: false

      t.timestamps
    end
  end
end
