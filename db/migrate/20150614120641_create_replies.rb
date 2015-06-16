class CreateReplies < ActiveRecord::Migration
  def change
    create_table :replies do |t|
      t.text :body
      t.integer :repliable_id
      t.string  :repliable_type
      t.integer :ticket_id

      t.timestamps null: false
    end
    add_index :replies, :ticket_id
    add_index :replies, :repliable_id
  end
end
