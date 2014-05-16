class CreateUserAndCategory < ActiveRecord::Migration
  def change
  	create_table :users do |t|
  	  t.string :name
  	  t.timestamps
  	end
  	create_table :categories do |t|
  	  t.string :name
  	end
  end
end
