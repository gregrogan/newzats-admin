class GroupsMember < ActiveRecord::Base
  belongs_to :member
  belongs_to :group
end
