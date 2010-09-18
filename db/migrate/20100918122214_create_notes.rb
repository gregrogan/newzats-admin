class CreateNotes < ActiveRecord::Migration
  def self.up
	 create_table :notes, :primary_key => :id do |t|
		t.integer :id
		t.integer :member_id
		t.string :content
		t.timestamp :modification_time
	 end
  end

  def self.down
	drop_table :notes
  end
end
