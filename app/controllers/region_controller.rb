class RegionController < ApplicationController
   def list
      @regions = Region.find(:all)
   end
   def show
	  @region = Region.find(params[:id])
	  @region_members = Member.find(:all, :conditions => ["region_id=? AND "+leave_cond, @region.id ])
	  @members = Array.new
	  @region_members.each do |rm|
	    if !(rm.deleted)
			@members << rm
		end
	  end
   end
   def new
      @region = Region.new
   end
   def create
      @region = Region.new(params[:region])
      if @region.save
		 flash[:notice] = "Successfully created region #{@region.name}"
		redirect_to :action => 'list'
      else
          render :action => 'new'
      end
   end
   def delete
      @region = Region.find(params[:id])
	  @linked_members = Array.new

	  @region_members = Member.find(:all, :conditions => { :region_id => @region.id })
	  @members = Array.new
	  @region_members.each do |rm|
	    if !(rm.deleted)
			@linked_members << rm
		end
	  end

	  if (@linked_members.length > 0)
	     flash[:notice] = "Can't delete this region because it contains these members! #{@linked_members.join(', ')}"
      else
		@region.destroy
        flash[:notice] = "Region #{@region.name} deleted"
      end
      redirect_to :action => 'list'

   end
end
