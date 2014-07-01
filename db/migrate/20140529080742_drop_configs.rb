class DropConfigs < ActiveRecord::Migration
  def change
    drop_table :configs
  end
end
