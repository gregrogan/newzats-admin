class MembershipType < ActiveRecord::Base
  has_many :members
end
