class AddAuthorCategoryToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :author, :int
    add_column :articles, :category, :int
  end
end
