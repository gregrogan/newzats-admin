class RenameMembershipTypeToMembershiptype < ActiveRecord::Migration
  def self.up
     	remove_column :members, :membership_type_id
        add_column :members, :membershiptype_id, :integer
  end

  def self.down
     	remove_column :members, :membershiptype_id
        add_column :members, :membership_type_id, :integer
  end
end
