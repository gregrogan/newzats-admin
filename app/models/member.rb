class Member < ActiveRecord::Base
  set_table_name "GDN_User"
  set_primary_key "UserID"
  has_many :groups_members
  has_many :groups, :through => :groups_members
  belongs_to :membership_type
  belongs_to :area
  validates_presence_of :FirstName
  validates_presence_of :membershiptype_id
  
  validates_format_of :Email,
    :allow_blank => :true,
	:with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i,
	:message => 'must be valid e.g someone@something.com'


  has_many :notes

  def first_name
	self.FirstName
  end

  def last_name
	self.LastName
  end
  
  def full_name
    [self.FirstName, self.LastName].join(' ')
  end

  def deleted
	if self.Deleted == 0
		return false
	else
		return true
	end
  end
  
  def email
	self.Email
  end
  
  def list_name
    if self.LastName == ''
      self.FirstName
    else
      [self.LastName, self.FirstName].join(', ')
    end
  end

  attr_accessor :group_ids
  after_save :update_groups

  #after_save callback to handle group_ids
  def update_groups
    unless group_ids.nil?
      self.groups_members.each do |m|
        m.destroy unless group_ids.include?(m.group_id.to_s)
        group_ids.delete(m.group_id.to_s)
      end
      group_ids.each do |g|
        self.groups_members.create(:group_id => g) unless g.blank?
      end
      reload
      self.group_ids = nil
    end
  end

  
  
end
