class MembershiptypeController < ApplicationController
   def list
      @membershiptypes = Membershiptype.find(:all)
   end
   def show
	  @membershiptype = Membershiptype.find(params[:id])
	  @membershiptype_members = Member.find(:all, :conditions => { :membershiptype_id => @membershiptype.id }, :order => :last_name)
	  @members = Array.new
	  @membershiptype_members.each do |rm|
	    if !(rm.deleted)
			@members << rm
		end
	  end
   end
   def new
      @membershiptype = Membershiptype.new
   end
   def create
      @membershiptype = Membershiptype.new(params[:membershiptype])
      if @membershiptype.save
		 flash[:notice] = "Successfully created membership type #{@membershiptype.name}"
		redirect_to :action => 'list'
      else
          render :action => 'new'
      end
   end
   def delete
      @membershiptype = Membershiptype.find(params[:id])
	  @linked_members = Array.new

	  @membershiptype_members = Member.find(:all, :conditions => { :membershiptype_id => @membershiptype.id })
	  @members = Array.new
	  @membershiptype_members.each do |rm|
	    if !(rm.deleted)
			@linked_members << rm
		end
	  end

	  if (@linked_members.length > 0)
	     flash[:notice] = "Can't delete this membership type because it contains these members! #{@linked_members.join(', ')}"
      else
		@membershiptype.destroy
        flash[:notice] = "Membership type #{@membershiptype.name} deleted"
      end
      redirect_to :action => 'list'

   end
end
