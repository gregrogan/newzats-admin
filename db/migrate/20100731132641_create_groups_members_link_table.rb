class CreateGroupsMembersLinkTable < ActiveRecord::Migration
  def self.up
    create_table :groups, :primary_key => :id do |t|
		t.integer :id
		t.string :name
	end
	create_table :groups_members, :primary_key => :id do |t|
		t.integer :id
		t.integer :member_id
		t.string :group_id
	end
  end

  def self.down
	drop_table :groups
	drop_table :groups_members
  end
end
