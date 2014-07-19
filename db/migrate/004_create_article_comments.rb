class CreateArticleComments < ActiveRecord::Migration
  def self.up
    create_table :article_comments do |t|
      t.string   :author
      t.text     :content
      t.integer  :article_id
      t.timestamps
    end
  end

  def self.down
    drop_table :article_comments
  end
end
