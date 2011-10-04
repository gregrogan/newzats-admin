class Payment < ActiveRecord::Base
  belongs_to :member
  belongs_to :user
end
