class AddApprovedToLink < ActiveRecord::Migration
  def self.up
	add_column :links, :approved, :boolean
  end

  def self.down
	remove_column :links, :approved
  end
end
