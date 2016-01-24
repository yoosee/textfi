class AddAltUrlToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :alt_url, :string
  end
end
