class CreatePayments < ActiveRecord::Migration
  def self.up
         create_table :payments, :primary_key => :id do |t|
                t.integer :id
                t.integer :member_id
                t.integer :year
                t.integer :amount
                t.string :method
                t.timestamp :modification_time
         end
  end

  def self.down
        drop_table :payments
  end
end
