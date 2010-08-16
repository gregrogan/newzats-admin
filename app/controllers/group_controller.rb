class GroupController < ApplicationController
   def list
      @groups = Group.find(:all)
   end
   def show
	  @group = Group.find(params[:id])
	  @groups_member = GroupsMember.find(:all, :conditions => { :group_id => @group.id })
	  @members = Array.new
	  @groups_member.each do |gm|
		@members << Member.find(gm.member_id)
	  end
   end
   def new
      @group = Group.new
   end
   def create
      @group = Group.new(params[:group])
      if @group.save
		 flash[:notice] = "Successfully created group #{@group.name}"
		redirect_to :action => 'list'
      else
          render :action => 'new'
      end
   end
   def delete
      group = Group.find(params[:id])
	  @linked_members = Array.new

	  GroupsMember.find(:all).each do |gm|
		  if ((Integer(group.id) - Integer(gm.group_id)) == 0)
		   @linked_members << "#{Member.find(gm.member_id).first_name} #{Member.find(gm.member_id).last_name}"
		  end
	  end
	  if (@linked_members.length > 0)
	     flash[:notice] = "Can't delete this group because it contains these members! #{@linked_members.join(', ')}"
      else
		group.destroy
        flash[:notice] = "Group #{group.name} deleted"
      end
      redirect_to :action => 'list'

   end
end
