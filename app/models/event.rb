class Event < ActiveRecord::Base
  validates_format_of :admin_email,
    :allow_blank => :true,
	:with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i,
	:message => 'must be valid e.g someone@something.com'

  def pretty_archive_date
	if archive_date
		archive_date.strftime("%e %B, %Y").strip
	end
  end  
end
