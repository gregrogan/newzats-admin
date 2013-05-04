class GdnUserIncShowProfile < ActiveRecord::Migration
  def self.up
            add_column :GDN_User, :show_profile_members, :boolean
            add_column :GDN_User, :show_profile_website, :boolean
  end

  def self.down
            remove_column :GDN_User, :show_profile_members
            remove_column :GDN_User, :show_profile_website
  end
end
