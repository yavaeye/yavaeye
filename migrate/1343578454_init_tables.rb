class InitTables < ActiveRecord::Migration
  def change
    create_table :prefs do |t|
      t.string :keys
      # NOTE if an hstore field = null, field || ('a' => 'b') will be null instead of a new hash
      #      so a default empty hash is required
      t.hstore :values, null: false, default: {}
    end

    create_table :users do |t|
      t.string :name, null: false
      t.string :email
      t.string :intro
      t.string :gravatar_id
      t.float :karma, null: false, default: 0.0

      t.datetime :deleted_at
      t.timestamps
    end

    create_table :profiles do |t|
      t.integer :user_id, null: false
      t.hstore :marked_post_ids, null: false, default: {}
      t.hstore :read_post_ids, null: false, default: {}
      t.hstore :tag_category, null: false, default: {}

      t.timestamps
    end

    create_table :mentions do |t|
      t.integer :user_id, null: false
      t.string :type
      t.string :link
      t.string :content
      t.boolean :read, default: false

      t.timestamps
    end

    create_table :posts do |t|
      t.integer :user_id, null: false
      t.string :title
      t.string :link
      t.string :domain
      t.float :score
      t.text :content
      t.text :content_html

      t.hstore :tags, null: false, default: {}
      t.column :keywords, 'tsvector'
      t.hstore :liker_ids, null: false, default: {}

      t.datetime :deleted_at
      t.timestamps
    end

    create_table :users_liked_posts, id: false do |t|
      t.integer :user_id, null: false
      t.integer :post_id, null: false
    end

    create_table :comments do |t|
      t.integer :user_id, null: false
      t.integer :post_id, null: false
      t.text :content
      t.text :content_html

      t.datetime :deleted_at
      t.timestamps
    end

    create_table :tags do |t|
      t.string :name, null: false
      t.text :content
      t.text :content_html

      t.timestamps
    end
  end
end
