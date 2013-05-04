class GdnUserIncBioWebsite < ActiveRecord::Migration
  def self.up
	add_column :GDN_User, :website, :string
	add_column :GDN_User, :bio, :text
  end

  def self.down
	remove_column :GDN_User, :website
	remove_column :GDN_User, :bio
  end
end
