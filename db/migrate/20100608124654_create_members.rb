class CreateMembers < ActiveRecord::Migration
  def self.up
    create_table :members, :primary_key => :id do |t|
		t.integer :id
		t.string :first_name
		t.string :middle_name
		t.string :last_name
		t.string :addr_1
		t.string :addr_2
		t.string :addr_3
		t.string :addr_4
		t.string :post_code
		t.string :email
		t.string :phone_work
		t.string :phone_home
		t.string :phone_mobile
		t.string :fax
		t.integer :region_id
		t.integer :group_id
		t.integer :membership_type_id
		t.date :date_joined
		t.boolean :council
		t.boolean :admissions
		t.boolean :leave
		t.boolean :deleted
      t.timestamps
	end
  end

  def self.down
      drop_table :members
  end
end