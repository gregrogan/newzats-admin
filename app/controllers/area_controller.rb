class AreaController < ApplicationController
   def list
      @areas = Area.find(:all)
   end
   def show
	  @area = Area.find(params[:id])
	  @area_members = Member.find(:all, :conditions => ["area_id=? AND "+leave_cond, @area.id ])
	  @members = Array.new
	  @area_members.each do |rm|
	    if !(rm.deleted)
			@members << rm
		end
	  end
   end
   def new
      @area = Area.new
   end
   def create
      @area = Area.new(params[:area])
      if @area.save
		 flash[:notice] = "Successfully created area #{@area.name}"
		redirect_to :action => 'list'
      else
          render :action => 'new'
      end
   end
   def delete
      @area = Area.find(params[:id])
	  @linked_members = Array.new

	  @area_members = Member.find(:all, :conditions => { :area_id => @area.id })
	  @members = Array.new
	  @area_members.each do |rm|
	    if !(rm.deleted)
			@linked_members << rm
		end
	  end

	  if (@linked_members.length > 0)
	     flash[:notice] = "Can't delete this area because it contains these members! #{@linked_members.join(', ')}"
      else
		@area.destroy
        flash[:notice] = "Area #{@area.name} deleted"
      end
      redirect_to :action => 'list'

   end
end
