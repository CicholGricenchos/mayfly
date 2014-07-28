class AddFieldsToArticles < ActiveRecord::Migration
  def self.up
    change_table :articles do |t|
      t.boolean :visible
    end
  end

  def self.down
    change_table :articles do |t|
      t.remove :visible
    end
  end
end
