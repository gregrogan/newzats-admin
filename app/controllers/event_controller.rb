require 'RMagick'

class EventController < ApplicationController
   def list
      @events = Event.find(:all)
   end
   def show
	  @event = Event.find(params[:id])
   end
   def new
      @event = Event.new
   end
   def edit
      @event = Event.find(params[:id])
   end
   def update
      @event = Event.find(params[:id])
	  @updated_event = params[:event]
	  if (params[:image_file])
		@updated_event[:image_file] = save_image_upload(:file => params[:image_file][:datafile], :width => 200, :height => 200)
	  end

      if @event.update_attributes(@updated_event)
  	    flash[:notice] = "Successfully saved."
	    redirect_to :action => 'show', :id => @event
	  else
	    redirect_to :action => 'edit', :id => @event
	  end
   end
   def create
      @event = Event.new(params[:event])
	  if (params[:image_file])
		@event[:image_file] = save_image_upload(:file => params[:image_file][:datafile], :width => 200, :height => 200)
	  end
      if @event.save
		 flash[:notice] = "Successfully created event #{@event.title}"
		redirect_to :action => 'list'
      else
          render :action => 'new'
      end
   end
   def delete
      @event = Event.find(params[:id])
	  #if (@event[:image_file] and File.exist?("#{RAILS_ROOT}/public/uploads/#{@event[:image_file]}"))
		#File.delete("#{RAILS_ROOT}/public/uploads/#{@event[:image_file]}")
	  #end
	  @event.destroy
      flash[:notice] = "Event #{@event.title} deleted"
      redirect_to :action => 'list'
   end
end
