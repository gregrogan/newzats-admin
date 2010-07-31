class Member < ActiveRecord::Base
  belongs_to :group
  belongs_to :membership_type
  belongs_to :region
  validates_presence_of :first_name
  validates_format_of :email,
	:with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i,
	:message => 'must be valid e.g someone@something.com'
  has_many :notes
end
