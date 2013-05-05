class VanillaForumsIntegrate < ActiveRecord::Migration
  def self.up
		rename_table :members, :members_pre_vanilla
		
		#assume GDN_User table from vanilla forums install
		add_column :GDN_User, :addr_1, :string
		add_column :GDN_User, :addr_2, :string
		add_column :GDN_User, :addr_3, :string
		add_column :GDN_User, :addr_4, :string
		add_column :GDN_User, :email_invalid, :boolean
		add_column :GDN_User, :post_code, :string
		add_column :GDN_User, :phone_work, :string
		add_column :GDN_User, :phone_home, :string
		add_column :GDN_User, :phone_mobile, :string
		add_column :GDN_User, :fax, :string
		add_column :GDN_User, :membershiptype_id, :integer
		add_column :GDN_User, :area_id, :integer
		add_column :GDN_User, :region_id, :integer
		add_column :GDN_User, :created_at, :timestamp
		add_column :GDN_User, :updated_at, :timestamp
		
		add_column :GDN_User, :website, :string
        	add_column :GDN_User, :bio, :text
		
		add_column :GDN_User, :show_profile_members, :boolean
		add_column :GDN_User, :show_profile_website, :boolean

		rename_table :regions, :areas

		create_table :regions, :primary_key => :id do |t|
			t.integer :id
			t.string :name
			t.timestamps
		end
		Region.create :name => "Northland"
		Region.create :name => "Auckland"
		Region.create :name => "Waikato"
		Region.create :name => "Bay of Plenty"
		Region.create :name => "Gisborne"
		Region.create :name => "Hawkes Bay"
		Region.create :name => "Taranaki"
		Region.create :name => "Wanganui"
		Region.create :name => "Manawatu"
		Region.create :name => "Wairarapa"
		Region.create :name => "Wellington"
		Region.create :name => "Nelson Bays"
		Region.create :name => "Marlborough"
		Region.create :name => "West Coast"
		Region.create :name => "Canterbury"
		Region.create :name => "Timaru - Oamaru"
		Region.create :name => "Otago"
		Region.create :name => "Southland"

 # copy all rows from members_pre_vanilla to GDN_User
execute "insert into GDN_User(UserID,Name,Email,Deleted,FirstName,LastName,addr_1,addr_2,addr_3,addr_4,email_invalid,post_code,phone_work,phone_home,phone_mobile,fax,membershiptype_id,area_id,created_at,updated_at,show_profile_members) select id,CONCAT(`first_name`,' ',`last_name`),email,deleted,first_name,last_name,addr_1,addr_2,addr_3,addr_4,email_invalid,post_code,phone_work,phone_home,phone_mobile,fax,membershiptype_id,region_id,created_at,updated_at,'1' from members_pre_vanilla"

 # ensure each user has a role of member
execute "insert into GDN_UserRole(UserID,RoleID) select id,'8' from members_pre_vanilla"

  end


  def self.down
		rename_table :members_pre_vanilla, :members

 #drop all except User_ID 1 in GDN_User table
execute "delete from GDN_User where UserID > 1"
 # same for user roles
execute "delete from GDN_UserRole where UserID > 1"

		remove_column :GDN_User, :addr_1
		remove_column :GDN_User, :addr_2
		remove_column :GDN_User, :addr_3
		remove_column :GDN_User, :addr_4
		remove_column :GDN_User, :email_invalid
		remove_column :GDN_User, :post_code
		remove_column :GDN_User, :phone_work
		remove_column :GDN_User, :phone_home
		remove_column :GDN_User, :phone_mobile
		remove_column :GDN_User, :fax
		remove_column :GDN_User, :membershiptype_id
		remove_column :GDN_User, :created_at
		remove_column :GDN_User, :updated_at
        	remove_column :GDN_User, :website
        	remove_column :GDN_User, :bio
		remove_column :GDN_User, :show_profile_members
		remove_column :GDN_User, :show_profile_website

		remove_column :GDN_User, :region_id
		remove_column :GDN_User, :area_id

		drop_table :regions
		rename_table :areas, :regions


		
  end
end

