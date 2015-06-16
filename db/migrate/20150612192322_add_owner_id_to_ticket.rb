class AddOwnerIdToTicket < ActiveRecord::Migration
  def change
    add_column :tickets, :owner_id, :integer
    add_index :tickets, :owner_id
  end
end
