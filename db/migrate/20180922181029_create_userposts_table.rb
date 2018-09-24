class CreateUserpostsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :userposts do |table|
      table.string :title
      table.string :description
      table.string :user_id
      table.string :classification
      table.timestamps
    end
  end
end
