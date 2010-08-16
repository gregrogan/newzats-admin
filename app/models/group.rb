class Group < ActiveRecord::Base
  has_many :groups_members
  has_many :members, :through => :groups_members
  validates_presence_of :name
end
