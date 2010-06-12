class Member < ActiveRecord::Base
  belongs_to :group
  belongs_to :membership_type
  belongs_to :region
  has_many :notes
end
