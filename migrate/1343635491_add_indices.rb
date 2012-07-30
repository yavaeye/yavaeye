class AddIndices < ActiveRecord::Migration
  def change
    add_index :users, :name
    add_index :users, :email
    add_index :posts, :user_id
    add_index :users_liked_posts, :user_id
    add_index :users_liked_posts, :post_id
    add_index :comments, :user_id
    add_index :comments, :post_id
    add_index :tags, :name
  end
end
