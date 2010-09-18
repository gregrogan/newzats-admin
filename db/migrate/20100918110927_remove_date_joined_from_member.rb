class RemoveDateJoinedFromMember < ActiveRecord::Migration
  def self.up
	remove_column :members, :date_joined
  end

  def self.down
	add_column :members, :date_joined, :date
  end
end
