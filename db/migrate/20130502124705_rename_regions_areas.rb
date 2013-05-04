class RenameRegionsAreas < ActiveRecord::Migration
  def self.up
    rename_table :regions, :areas
    rename_column :GDN_User, :region_id, :area_id
  end

  def self.down
    rename_table :areas, :regions
    rename_column :GDN_User, :area_id, :region_id
  end
end
