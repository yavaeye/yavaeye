class InitTables < ActiveRecord::Migration
  def change
    create_table :prefs do |t|
      t.string :keys
      t.hstore :values
    end

    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :intro
      t.string :gravatar_id
      t.float :karma, default: 0.0

      t.timestamps
    end

    create_table :profiles do |t|
      t.integer :user_id
      t.column :marked_post_ids, 'integer[]'
      t.column :read_post_ids, 'integer[]'
      t.column :mentions, 'hstore' # type: text
      t.column :tag_category, 'hstore'

      t.timestamps
    end

    create_table :posts do |t|
      t.integer :user_id
      t.string :title
      t.string :link
      t.string :domain
      t.float :score
      t.text :content
      t.text :content_html

      t.column :tags, 'varchar(255)[]'
      t.column :keywords, 'tsvector'
      t.column :liker_ids, 'integer[]'

      t.date :deleted_at
      t.timestamps
    end

    create_table :users_liked_posts, id: false do |t|
      t.integer :user_id
      t.integer :post_id
    end

    create_table :comments do |t|
      t.integer :user_id
      t.integer :post_id
      t.text :content
      t.text :content_html

      t.date :deleted_at
      t.timestamps
    end

    create_table :tags do |t|
      t.string :name
      t.text :content
      t.text :content_html

      t.timestamps
    end
  end
end
