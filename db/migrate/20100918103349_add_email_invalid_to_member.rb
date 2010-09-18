class AddEmailInvalidToMember < ActiveRecord::Migration
  def self.up
	    add_column :members, :email_invalid, :boolean
  end

  def self.down
	    remove_column :members, :email_invalid
  end
end
