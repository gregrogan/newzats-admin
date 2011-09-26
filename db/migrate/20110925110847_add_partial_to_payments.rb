class AddPartialToPayments < ActiveRecord::Migration
  def self.up
    add_column :payments, :partial, :boolean
  end

  def self.down
    remove_column :payments, :partial
  end
end
