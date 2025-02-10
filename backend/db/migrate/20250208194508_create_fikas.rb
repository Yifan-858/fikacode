class CreateFikas < ActiveRecord::Migration[8.0]
  def change
    create_table :fikas do |t|
      t.integer :sender_id, null: false
      t.string :sender_name, null: false
      t.integer :receiver_id, null: false
      t.string :receiver_name, null: false
      t.string :status, default: "pending"
      t.datetime :scheduled_at, null: false
      t.string :fika_id, null: false

      t.timestamps
    end
    add_index :fikas, :fika_id, unique: true
  end
end
