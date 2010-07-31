class MemberController < ApplicationController
   def email
      @members = Member.find(:all, :conditions => ["deleted is NULL"])
   end
   def search
	  term = params[:term]
	  @members = Member.find(:all, :conditions => ["first_name = "+term])
   end
   def list
      @members = Member.find(:all, :conditions => ["deleted is NULL"])
   end
   def show
      @member = Member.find(params[:id])
   end
   def new
      @member = Member.new
   end
   def create
      @member = Member.new(params[:member])
      if @member.save
		 flash[:notice] = "Successfully saved."
		redirect_to :action => 'list'
      else
          render :action => 'new'
      end
   end
   def edit
      @member = Member.find(params[:id])
   end
   def update
        @member = Member.find(params[:id])
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
