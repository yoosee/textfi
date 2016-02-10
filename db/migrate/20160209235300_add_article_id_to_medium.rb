class AddArticleIdToMedium < ActiveRecord::Migration
  def change
    add_column :media, :article_id, :integer
  end
end
