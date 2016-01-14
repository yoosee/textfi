class AddStatusToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :status, :enum
  end
end
