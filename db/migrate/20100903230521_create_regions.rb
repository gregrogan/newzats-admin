class CreateRegions < ActiveRecord::Migration
  def self.up
      create_table :regions, :primary_key => :id do |t|
		t.integer :id
		t.string :name
      t.timestamps
	end
  end

  def self.down
      drop_table :regions
  end
end
