class UserSessionsController < ApplicationController
  skip_before_filter :login_required
  def new  
    @user_session = UserSession.new  
  end  
  
  def create  
    @user = User.find_by_login(params[:user_session][:login])
    if @user.disabled
      flash[:notice] = "User "+@user.name+" is disabled"
      redirect_to :action => :new
      return
    end
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save 
      flash[:notice] = "Login successful!"
      redirect_to :controller => :member, :action => :list
    else  
      render :action => :new  
    end  
  end  
  def destroy  
    if current_user_session
      current_user_session.destroy
      flash[:notice] = "Logged out!"
    end
    redirect_to :action => :new
  end
end
