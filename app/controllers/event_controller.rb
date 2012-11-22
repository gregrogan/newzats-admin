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
   def save_file(args)
	@file = args[:file]
	# create the file path
	file_name = Time.now.to_f.to_s+File.extname(@file.original_filename)
	path = File.join("public/uploads", file_name)
	image = Magick::Image.from_blob(@file.read).first
	resized_img = image.resize_to_fit(200, 200)
	# write the file
	resized_img.write(path)
	return file_name
   end
   def update
      @event = Event.find(params[:id])
	  @updated_event = params[:event]
	  if (params[:image_file])
		@updated_event[:image_file] = save_file(:file => params[:image_file][:datafile])
	  end

      if @event.update_attributes(@updated_event)
  	    flash[:notice] = "Successfully saved."
	    redirect_to :action => 'show', :id => @event
	  else
	    redirect_to :action => 'edit'
	  end
   end
   def create
      @event = Event.new(params[:event])
	  if (params[:image_file])
		@event[:image_file] = save_file(:file => params[:image_file][:datafile])
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
