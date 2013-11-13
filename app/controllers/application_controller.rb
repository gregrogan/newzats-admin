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

  def newzats_members_url
	if Rails.env == "development"
	  return "http://newzatsdev.gregrogan.com/members"
	elsif Rails.env == "production"
	  return "http://newzats.org.nz/members"
	end
  end
  
  def newzats_members_path
	if Rails.env == "development"
	  return "/var/www/newzatsdev/members"
	elsif Rails.env == "production"
	  return "/var/www/newzats/members"
	end
  end
  
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
  def save_image_upload(args)
  @file = args[:file]
  # create the file path
  folder = "/uploads/"
  file_name = folder+@file.original_filename
  original_filename = file_name
  i = 1
  while File.exist?("public"+file_name)
  	file_name = original_filename.gsub(/\.(.)+$/,"_#{i}#{File.extname(file_name)}")
  	i += 1
  end
  image = Magick::Image.from_blob(@file.read).first
  resized_img = image.resize_to_fit(args[:width], args[:height])
  # write the file
  resized_img.write("public"+file_name)
  return file_name
  end

  
  def save_profile_photo_upload(args)
  @file = args[:file]

  file_name = @file.original_filename
  original_filename = file_name
  i = 1
  while File.exist?(ApplicationController.new.newzats_members_path+"/uploads/userpics/p"+file_name)
  	file_name = original_filename.gsub(/\.(.)+$/,"_#{i}#{File.extname(file_name)}")
  	i += 1
  end
  image = Magick::Image.from_blob(@file.read).first
  resized_img = image.resize_to_fit(args[:width], args[:height])

  # write the file
  resized_img.write(ApplicationController.new.newzats_members_path+"/uploads/userpics/p"+file_name)

  # resized thumbnail for vanilla
  resized_img = image.resize_to_fit('40', '40')
  resized_img.write(ApplicationController.new.newzats_members_path+"/uploads/userpics/n"+file_name)
  
  file_name = "userpics/"+file_name;
  return file_name
  end

  def leave_cond()
    @membershiptype = Membershiptype.find(:all, :conditions=>{:name => "Leave of absence"})[0]
    if (@membershiptype)
    	return "membershiptype_id != "+@membershiptype.id.to_s
    end
    return "1 = 1"
  end
  
end
