# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  before_filter :login_required

  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  # From authlogic  
  filter_parameter_logging :password, :password_confirmation  
  helper_method :current_user_session, :current_user  
  
  private  
  def current_user_session  
    @current_user_session ||= UserSession.find  
  end  
  
  def current_user  
    @current_user ||= current_user_session && current_user_session.user  
  end  
  def login_required

    @logged_out = true
    if current_user
      @logged_out = false
    end

    @user_disabled = false
    if current_user && User.find(current_user.id).disabled
      @user_disabled = true
    end

    if @logged_out || @user_disabled
      redirect_to :action => 'new', :controller => 'user_sessions' 
    end
  end
end
