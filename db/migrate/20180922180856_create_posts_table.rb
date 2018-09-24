class CreatePostsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |table|
      table.string :title
      table.string :description
      table.string :user_id
      table.timestamps
    end
  end
end

