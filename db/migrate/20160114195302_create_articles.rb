class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title
      t.text :content
      t.integer :user_id
      t.integer :blog_id
      t.datetime :published_at

      t.timestamps null: false
    end
  end
end
