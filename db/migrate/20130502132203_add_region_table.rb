class AddRegionTable < ActiveRecord::Migration
  def self.up
      create_table :regions, :primary_key => :id do |t|
                t.integer :id
                t.string :name
      t.timestamps
        end
      add_column :GDN_User, :region_id, :integer

Region.create :name => "Northland"
Region.create :name => "Auckland"
Region.create :name => "Waikato"
Region.create :name => "Bay of Plenty"
Region.create :name => "Gisborne"
Region.create :name => "Hawkes Bay"
Region.create :name => "Taranaki"
Region.create :name => "Wanganui"
Region.create :name => "Manawatu"
Region.create :name => "Wairarapa"
Region.create :name => "Wellington"
Region.create :name => "Nelson Bays"
Region.create :name => "Marlborough"
Region.create :name => "West Coast"
Region.create :name => "Canterbury"
Region.create :name => "Timaru - Oamaru"
Region.create :name => "Otago"
Region.create :name => "Southland"

  end

  def self.down
      drop_table :regions
      remove_column :GDN_User, :region_id
  end
end

