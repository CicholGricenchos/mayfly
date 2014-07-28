class CreateSiteConfigs < ActiveRecord::Migration
  def self.up
    create_table :site_configs do |t|
      t.string :name
      t.string :value
      #t.timestamps
    end
  end

  def self.down
    drop_table :site_configs
  end
end
