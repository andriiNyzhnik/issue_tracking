class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.string :department
      t.string :subject
      t.text :content

      t.timestamps null: false
    end
  end
end
