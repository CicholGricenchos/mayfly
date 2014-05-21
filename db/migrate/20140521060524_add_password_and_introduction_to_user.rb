class AddPasswordAndIntroductionToUser < ActiveRecord::Migration
  def change
    add_column :users, :password, :string
    add_column :users, :introduction, :text
  end
end
