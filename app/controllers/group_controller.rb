class GroupController < ApplicationController
   def list
      @groups = Group.find(:all)
   end
   def show
	  @group = Group.find(params[:id])
	  @groups_member = GroupsMember.find(:all, :conditions => { :group_id => @group.id })
	  @members = Array.new
	  @groups_member.each do |gm|
		@member = Member.find(gm.member_id)
	    if !(@member.deleted)
			@members << @member
		end
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
	      @member = Member.find(gm.member_id)
		  if ( ((Integer(group.id) - Integer(gm.group_id)) == 0) && !(@member.deleted) )
		   @linked_members << "#{@member.first_name} #{@member.last_name}"
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
   def members
    @group = Group.find(params[:id])
	@members = Member.find(:all, :conditions => ["deleted is NULL"])
   end
   def update_members
    @group = Group.find(params[:id])
	@group.update_attributes(params[:group])
	flash[:notice] = "Updated members."
    redirect_to :action => 'show'
   end
end
