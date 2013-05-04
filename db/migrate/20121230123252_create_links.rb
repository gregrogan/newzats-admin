class CreateLinks < ActiveRecord::Migration
  def self.up
	create_table :links, :primary_key => :id do |t|
		t.integer :id
		t.string :name
		t.string :url
		t.string :icon
		t.string :desc
	end
  end

  def self.down
	drop_table :links
  end
end
