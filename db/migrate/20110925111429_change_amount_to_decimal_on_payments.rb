class ChangeAmountToDecimalOnPayments < ActiveRecord::Migration
  def self.up
    change_column :payments, :amount, :decimal
  end

  def self.down
    change_column :payments, :amount, :integer
  end
end
