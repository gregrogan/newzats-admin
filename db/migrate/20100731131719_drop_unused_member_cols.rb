class DropUnusedMemberCols < ActiveRecord::Migration
  def self.up
	remove_column :members, :group_id
	remove_column :members, :council
	remove_column :members, :admissions
	remove_column :members, :leave
  end

  def self.down
    add_column :members, :group_id, :integer
    add_column :members, :council, :boolean
    add_column :members, :admissions, :boolean
    add_column :members, :leave, :boolean
  end
end
