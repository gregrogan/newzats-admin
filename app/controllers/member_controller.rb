class MemberController < ApplicationController
   def email
      @members = Member.find(:all, :conditions => ["deleted is NULL"])
   end
   def search
	  @term = params[:term]
	  @members = Member.find(:all, :conditions => [
		"deleted is NULL AND 
		(first_name like ? OR
		 last_name like ? OR
		 email like ? OR
		 addr_1 like ? OR
		 addr_2 like ? OR
		 addr_3 like ? OR
		 addr_4 like ? OR
		 post_code like ? OR
		 phone_work like ? OR
		 phone_home like ? OR
		 phone_mobile like ? OR
		 fax like ?
		 )", 
			"%"+@term+"%",
			"%"+@term+"%",
			"%"+@term+"%",
			"%"+@term+"%",
			"%"+@term+"%",
			"%"+@term+"%",
			"%"+@term+"%",
			"%"+@term+"%",
			"%"+@term+"%",
			"%"+@term+"%",
			"%"+@term+"%",
			"%"+@term+"%"
		])
   end
   def list
      @members = Member.find(:all, :conditions => ["deleted is NULL"])
   end
   def show
      @member = Member.find(params[:id])
	  if !(@member.deleted)
		  @groups_member = GroupsMember.find(:all, :conditions => { :member_id => @member.id })
		  @groups = Array.new
		  @groups_member.each do |gm|
			@groups << Group.find(gm.group_id)
		  end
	  end
   end
   def new
      @member = Member.new
	  @groups = Group.find(:all)
   end
   def create
      @member = Member.new(params[:member])
	  @groups = Group.find(:all)
      if @member.save
		 flash[:notice] = "Successfully saved."
		redirect_to :action => 'list'
      else
          render :action => 'new'
      end
   end
   def edit
      @member = Member.find(params[:id])
	  @groups = Group.find(:all)
   end
   def update
        @member = Member.find(params[:id])
		@groups = Group.find(:all)
      if @member.update_attributes(params[:member])
		 flash[:notice] = "Successfully saved."
         redirect_to :action => 'show', :id => @member
      else
         render :action => 'edit'
      end
   end
   def delete
      @member = Member.find(params[:id])
	  @member.deleted = true
	  @member.save
      redirect_to :action => 'list'

   end
end
