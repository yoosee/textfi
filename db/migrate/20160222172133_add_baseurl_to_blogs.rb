class AddBaseurlToBlogs < ActiveRecord::Migration
  def change
    add_column :blogs, :baseurl, :text
  end
end
