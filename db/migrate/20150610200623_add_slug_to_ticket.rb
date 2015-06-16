class AddSlugToTicket < ActiveRecord::Migration
  def change
    add_column :tickets, :slug, :string
    add_index :tickets, :slug, unique: true
  end
end
