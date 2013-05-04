class LinkController < ApplicationController
   def list
      @links = Link.find(:all, :order => "'order' ASC")
   end
   def new
      @link = Link.new
   end
   def edit
      @link = Link.find(params[:id])
   end
   def update
      @link = Link.find(params[:id])
	  @updated_link = params[:link]
	  if (params[:icon])
		@updated_link[:icon] = save_image_upload(:file => params[:icon][:datafile], :width => 80, :height => 200)
	  end

      if @link.update_attributes(@updated_link)
  	    flash[:notice] = "Successfully saved."
	    redirect_to :action => 'list', :id => @link
	  else
	    redirect_to :action => 'edit', :id => @link
	  end
   end
   def create
      @link = Link.new(params[:link])
	  if (params[:icon])
		@link[:icon] = save_image_upload(:file => params[:icon][:datafile], :width => 80, :height => 200)
	  end
      if @link.save
		 flash[:notice] = "Successfully created link #{@link.name}"
		redirect_to :action => 'list'
      else
          render :action => 'new'
      end
   end
   def delete
      @link = Link.find(params[:id])
	  @link.destroy
      flash[:notice] = "Link #{@link.name} deleted"
      redirect_to :action => 'list'
   end
end