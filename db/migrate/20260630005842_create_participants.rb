class CreateParticipants < ActiveRecord::Migration[8.1]
  def change
    create_table :participants do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :document_number, null: false

      t.timestamps
    end
    add_index :participants, :document_number, unique: true
  end
end
