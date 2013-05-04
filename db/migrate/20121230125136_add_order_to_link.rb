class AddOrderToLink < ActiveRecord::Migration
  def self.up
	add_column :links, :order, :integer
  end

  def self.down
	remove_column :links, :order
  end
end
