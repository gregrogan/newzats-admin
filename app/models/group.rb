class Group < ActiveRecord::Base
  has_many :groups_members
  has_many :members, :through => :groups_members
  validates_presence_of :name
  
  attr_accessor :member_ids
  after_save :update_members

  #after_save callback to handle members_ids
  def update_members
   unless member_ids.nil?
      self.groups_members.each do |m|
        m.destroy unless member_ids.include?(m.member_id.to_s)
        member_ids.delete(m.member_id.to_s)
		@note = Note.new
		@note.member_id = m.member_id
		@note.content = "- removed from group "+Group.find(m.group_id).name
		@note.modification_time = Time.now
		@note.save
      end
      member_ids.each do |m|
        self.groups_members.create(:member_id => m) unless m.blank?
		unless m.blank?
			@note = Note.new
			@note.member_id = m
			@note.content = "- added to group "+self.name
			@note.modification_time = Time.now
			@note.save
		end
      end
      reload
      self.member_ids = nil
	end
  end
end
