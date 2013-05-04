class MemberController < ApplicationController

  def pdf_print
   @members = Member.find(:all, :conditions => ["deleted != 1"])
  end
  def render_pdf
   @members = Member.find(params[:member_id])
   @members = @members.sort_by { |m| m.list_name }
   respond_to do |format|
    format.pdf { render :layout => false }
    if params[:label]
      @document = "label"
      prawnto :filename => "mail labels.pdf", :prawn => { :margin => [0, 10, 0, 24] }
    elsif params[:subs]
      @document = "subs"
      prawnto :filename => "subs.pdf"
    end
   end
  end
   def csv
   	@members = Member.find(:all, :conditions => ["deleted != 1"])
        @members = @members.sort_by { |m| m.list_name }
	@groups = Array.new
	Group.find(:all).each do |g|
		@groups << "Group: " + g.name
	end
        @current_year = Time.new.year
        @payment_years = [@current_year-5,
                          @current_year-4,
                          @current_year-3,
                          @current_year-2,
                          @current_year-1,
                          @current_year,
                          @current_year+1]
        @payment_years_header = Array.new
        @payment_years.each do |p|
          @payment_years_header << "Subs: " + p.to_s()
        end
    	csv_string = FasterCSV.generate do |csv|
    		# header row
    		csv << ["ID", "First Name", "Middle Name", "Last Name", "Address Line 1", "Address Line 2", "Address Line 3", "Address Line 4", "Post Code", "Email", "Email Invalid?", "Work Phone", "Home Phone", "Mobile Phone", "Fax", "Area", "Region", "Membership Type"] + @payment_years_header + @groups

    		# data rows
    		@members.each do |member|
                        if  (member.email_invalid)
 				@email_invalid = 'true'
			else @email_invalid = ''
			end

                        @payments = Array.new
                        @payment_years.each do |year|
                          if (Payment.find(:all, :conditions => { :member_id => member.id, :year => year, :partial => false }) != [])
                            @payments << 'Yes'
                          elsif (Payment.find(:all, :conditions => { :member_id => member.id, :year => year, :partial => true }) != [])
                            @payments << 'Partial'
                          else
                            @payments << ''
                          end
                        end


			@member_groups = Array.new
			Group.find(:all).each do |g|
				if (GroupsMember.find(:all, :conditions => { :member_id => member.id, :group_id => g.id }) != [])
					@member_groups << 'Yes'
				else @member_groups << ''
				end
			end
 			@member_area
                       	@member_area = Area.find(member.area).name if member.area
 			@member_region
                       	@member_region = Region.find(member.region).name if member.region

      			csv << [member.id, member.FirstName, member.MiddleName, member.LastName, member.addr_1, member.addr_2, member.addr_3, member.addr_4, member.post_code, member.email, @email_invalid, member.phone_work, member.phone_home, member.phone_mobile, member.fax, @member_area, @member_region, Membershiptype.find(member.membershiptype_id).name] + @payments + @member_groups
    		end
  	end
	@time = Time.new.strftime("%d-%m-%Y")
  	# send it to the browsah
 	send_data csv_string,
            :type => 'text/csv; charset=iso-8859-1; header=present',
            :disposition => "attachment; filename=newzats-members-" + @time + ".csv"
   end
   def email
      @type = params[:type]
      @conditions = ""

      @groups = Group.find(:all)
      @areas = Area.find(:all)
      @regions = Region.find(:all)
      @membershiptypes = Membershiptype.find(:all)
      
      @all_emailing_members = Member.find(:all, :conditions => ["deleted != 1 AND (email_invalid is NULL OR email_invalid = 'f') AND email > ''"])

      @member_slice = Array.new
@debug = ""
      if (!@type || @type == 'all')
        @member_slice = @all_emailing_members
      elsif (@type == "paid")
        @all_emailing_members.each do |m|
          if (Payment.find(:all, :conditions => { :member_id => m.id, :year => Time.now.strftime('%Y'), :partial => false }) != [])
            @member_slice << m
          end
        end
      elsif (@type == "unpaid")
        @all_emailing_members.each do |m|
          if (Payment.find(:all, :conditions => { :member_id => m.id, :year => Time.now.strftime('%Y'), :partial => false }) == [])
            @member_slice << m
          end
        end
      elsif (@type.start_with?("group:"))
        @group_id = @type.split(":").pop.to_i
        @all_emailing_members.each do |m|
          if (GroupsMember.find(:all, :conditions => { :group_id => @group_id, :member_id => m.id }) != [])
            @member_slice << m
          end
        end
      elsif (@type.start_with?("area:"))
        @area_id = @type.split(":").pop.to_i
        @all_emailing_members.each do |m|
          if ( m.area_id == @area_id )
            @member_slice << m
          end
        end
      elsif (@type.start_with?("region:"))
        @region_id = @type.split(":").pop.to_i
        @all_emailing_members.each do |m|
          if ( m.region_id == @region_id )
            @member_slice << m
          end
        end
      elsif (@type.start_with?("membershiptype:"))
        @membershiptype_id = @type.split(":").pop.to_i
        @all_emailing_members.each do |m|
          if ( m.membershiptype_id == @membershiptype_id )
            @member_slice << m
          end
        end
      end
      @members = @member_slice.sort_by { |m| m.list_name }
   end
   def search
	  @term = params[:term]
          @term = '' if !@term #ensure term is not null so below find works
	  @members = Member.find(:all, :conditions => [
		"deleted != 1 AND 
		(UserId like ? OR
		 FirstName like ? OR
		 LastName like ? OR
		 email like ? OR
		 addr_1 like ? OR
		 addr_2 like ? OR
		 addr_3 like ? OR
		 addr_4 like ? OR
		 post_code like ? OR
		 phone_work like ? OR
		 phone_home like ? OR
		 phone_mobile like ? OR
		 fax like ?
		 )", 
			"%"+@term+"%",
			"%"+@term+"%",
			"%"+@term+"%",
			"%"+@term+"%",
			"%"+@term+"%",
			"%"+@term+"%",
			"%"+@term+"%",
			"%"+@term+"%",
			"%"+@term+"%",
			"%"+@term+"%",
			"%"+@term+"%",
			"%"+@term+"%",
			"%"+@term+"%"
		])
   end
   def notes
		@member = Member.find(params[:id])
		@notes = Note.find(:all, :conditions => {:member_id => @member.id}, :order => 'modification_time DESC' )
   end
   def create_note
              @member = Member.find(params[:id])
	      @note = Note.new(params[:note])
		  @note.member_id = params[:id]
                  @note.user_id = current_user.id
		  @note.modification_time = Time.now
		  @note.save
                  respond_to do |format|
                    format.html {
		      flash[:notice] = "Note saved."
                      redirect_to :action => 'show', :id => @member
                    }
                    format.json {
                      render :json => { :on => @note.modification_time.in_time_zone("Auckland").strftime("%d-%b-%Y, %I:%M%p"), :by => User.find(@note.user_id).name, :content => @note.content }
                    }
                  end

   end
   def list
      @members = Member.find(:all, :conditions => ["deleted != 1"])
   end
   def show
      @member = Member.find(params[:id])
      @notes = Note.find(:all, :conditions => {:member_id => @member.id}, :order => 'modification_time DESC' )
      @payments = Payment.find(:all, :conditions => {:member_id => @member.id}, :order => 'modification_time DESC' )
	  if (@member.deleted)
	    flash[:notice] = "Error: This member (id #{@member.id}) has been deleted"
		redirect_to :action => 'list'
	  end
	  @has_any_address
	  if ((@member.addr_1 && @member.addr_1 > '') || (@member.addr_2 && @member.addr_2 > '') || (@member.addr_3 && @member.addr_3 > '') || (@member.addr_4 && @member.addr_4 > '') || (@member.post_code && @member.post_code > ''))
		@has_any_address = 'true'
	  end
	  @has_any_phone
	  if ((@member.phone_work && @member.phone_work > '') || (@member.phone_home && @member.phone_home > '') || (@member.phone_mobile && @member.phone_mobile > '') || (@member.fax && @member.fax > ''))
		@has_any_phone = 'true'
	  end

	  @email_display
	  if (@member.email_invalid)
		@email_display = 'invalid'
	  else
	    @email_display = 'valid'
	  end
	  if !(@member.deleted)
		  @groups_member = GroupsMember.find(:all, :conditions => { :member_id => @member.id })
		  @groups = Array.new
		  @groups_member.each do |gm|
			@groups << Group.find(gm.group_id)
		  end
	  end
          @payment_methods = ["Bank account deposit","Cheque","Cash","Credit Card"]
          @current_year = Time.new.year
          @year_options = [@current_year-5,
                          @current_year-4,
                          @current_year-3,
                          @current_year-2,
                          @current_year-1,
                          @current_year,
                          @current_year+1,
                          @current_year+2,
                          @current_year+3,
                          @current_year+4,
                          @current_year+5]
          @paid = false
          if (Payment.find(:all, :conditions => { :member_id => @member.id, :year => Time.now.strftime('%Y'), :partial => false }) != [])
            @paid = true
          end
   end
   def new
      @member = Member.new
	  @groups = Group.find(:all)
	  @areas = Area.find(:all)
	  @regions = Region.find(:all)
	  @membershiptypes = Membershiptype.find(:all)
   end
   def create
      @member = Member.new(params[:member])
	  @member.DateInserted = Time.now
	  @member.Name = @member.full_name
	  @member.Password = " "
	  
	  @groups = Group.find(:all)
	  @areas = Area.find(:all)
	  @regions = Region.find(:all)
	  @membershiptypes = Membershiptype.find(:all)

 	  if (params[:Photo])
		@member[:Photo] = save_profile_photo_upload(:file => params[:Photo][:datafile], :width => 200, :height => 200)
	  end
	  
      if @member.save
		  member_role_id = ActiveRecord::Base.connection.execute("select RoleID from GDN_Role where Name='Member'").fetch_row[0]
		  ActiveRecord::Base.connection.execute("insert into GDN_UserRole(UserID,RoleID) values ("+@member.id.to_s+","+member_role_id+")")
	      @note = Note.new
		  @note.member_id = @member.id
		  @note.content = note_created_with(:member => @member)
		  @note.modification_time = Time.now
                  @note.user_id = current_user.id
		  @note.save
		 flash[:notice] = "Successfully saved."
		redirect_to :action => 'list'
      else
          render :action => 'new'
      end
   end
   def edit
      @member = Member.find(params[:id])
	  @groups = Group.find(:all)
	  @areas = Area.find(:all)
	  @regions = Region.find(:all)
	  @membershiptypes = Membershiptype.find(:all)
	  @selected_area
	  if @member.area_id
		@selected_area = Area.find(@member.area_id)
	  end
	  @selected_region
	  if @member.region_id && @member.region_id != 0
		@selected_region = Region.find(@member.region_id)
	  end
	  @selected_membershiptype
	  if @member.membershiptype_id
		@selected_membershiptype = Membershiptype.find(@member.membershiptype_id)
	  end
   end
   def update
      @member = Member.find(params[:id])
	  @member.Name = params[:member][:FirstName]+" "+params[:member][:LastName]
	  @member.DateUpdated = Time.now
      @orig_member = Member.find(params[:id])
      @orig_groups_member = GroupsMember.find(:all, :conditions => { :member_id => @member.id })
	  
	  if (params[:Photo])
		@member[:Photo] = save_profile_photo_upload(:file => params[:Photo][:datafile], :width => 200, :height => 200)
	  end
	  
      if @member.update_attributes(params[:member])
	  @note_content = note_what_has_changed(:orig_member => @orig_member, :member => @member, :orig_groups_member => @orig_groups_member)
          if (@note_content)
	     @note = Note.new
	     @note.member_id = @member.id
	     @note.content = @note_content
	     @note.modification_time = Time.now
             @note.user_id = current_user.id
	     @note.save
	     flash[:notice] = "Successfully saved."
          end
          redirect_to :action => 'show', :id => @member
      else
	  	  @groups = Group.find(:all)
		  @areas = Area.find(:all)
		  @regions = Region.find(:all)
		  @membershiptypes = Membershiptype.find(:all)
         render :action => 'edit'
      end
   end
   def delete
      @member = Member.find(params[:id])
	  @member.Deleted = true
	  @member.save
	  ActiveRecord::Base.connection.execute("delete from GDN_UserRole where UserID = "+@member.id.to_s)
	  @note = Note.new
	  @note.member_id = @member.id
          @note.user_id = current_user.id
	  @note.content = '- deleted this member'
	  @note.modification_time = Time.now
	  @note.save

      redirect_to :action => 'list'

   end
   
   def note_what_has_changed(args)
    @orig_member = args[:orig_member]
	@member = args[:member]
	@orig_groups_member = args[:orig_groups_member]
	@change
	@changes = ''
	
	@change = add_rem_change(:orig => @orig_member.FirstName, :new => @member.FirstName, :field_name => 'First Name')
	@changes.concat("- #{@change}<br/>") if @change > ''

	@change = add_rem_change(:orig => @orig_member.MiddleName, :new => @member.MiddleName, :field_name => 'Middle Name')
	@changes.concat("- #{@change}<br/>") if @change > ''

	@change = add_rem_change(:orig => @orig_member.LastName, :new => @member.LastName, :field_name => 'Last Name')
	@changes.concat("- #{@change}<br/>") if @change > ''

	@change = add_rem_change(:orig => @orig_member.email, :new => @member.email, :field_name => 'Email')
	@changes.concat("- #{@change}<br/>") if @change > ''

	if @orig_member.email_invalid != @member.email_invalid
		@changes.concat("- Email address invalid changed from #{@orig_member.email_invalid} to #{@member.email_invalid}<br/>")
	end

	@change = add_rem_change(:orig => @orig_member.website, :new => @member.website, :field_name => 'Website')
	@changes.concat("- #{@change}<br/>") if @change > ''

	@change = add_rem_change(:orig => @orig_member.bio, :new => @member.bio, :field_name => 'Bio')
	@changes.concat("- #{@change}<br/>") if @change > ''

	if @orig_member.Photo != @member.Photo
		@changes.concat("- Photo <img class='profile' src='#{ApplicationController.new.newzats_members_url+"/uploads/"+File.dirname(@member.Photo)+"/p"+File.basename(@member.Photo)}'/><br/>")
	end
	
	@change = add_rem_change(:orig => @orig_member.addr_1, :new => @member.addr_1, :field_name => 'Address line 1')
	@changes.concat("- #{@change}<br/>") if @change > ''

	@change = add_rem_change(:orig => @orig_member.addr_2, :new => @member.addr_2, :field_name => 'Address line 2')
	@changes.concat("- #{@change}<br/>") if @change > ''

	@change = add_rem_change(:orig => @orig_member.addr_3, :new => @member.addr_3, :field_name => 'Address line 3')
	@changes.concat("- #{@change}<br/>") if @change > ''

	@change = add_rem_change(:orig => @orig_member.addr_4, :new => @member.addr_4, :field_name => 'Address line 4')
	@changes.concat("- #{@change}<br/>") if @change > ''

	@change = add_rem_change(:orig => @orig_member.post_code, :new => @member.post_code, :field_name => 'Post code')
	@changes.concat("- #{@change}<br/>") if @change > ''

	@change = add_rem_change(:orig => @orig_member.phone_work, :new => @member.phone_work, :field_name => 'Work phone')
	@changes.concat("- #{@change}<br/>") if @change > ''

	@change = add_rem_change(:orig => @orig_member.phone_home, :new => @member.phone_home, :field_name => 'Home phone')
	@changes.concat("- #{@change}<br/>") if @change > ''

	@change = add_rem_change(:orig => @orig_member.phone_mobile, :new => @member.phone_mobile, :field_name => 'Mobile phone')
	@changes.concat("- #{@change}<br/>") if @change > ''

	@change = add_rem_change(:orig => @orig_member.fax, :new => @member.fax, :field_name => 'Fax')
	@changes.concat("- #{@change}<br/>") if @change > ''

	if @orig_member.area_id && @orig_member.area_id != 0
		@orig_val = Area.find(@orig_member.area_id).name
	else
		@orig_val = ''
	end
	if @member.area_id && @member.area_id != 0
		@new_val = Area.find(@member.area_id).name
	else
		@new_val = ''
	end
	@change = add_rem_change(:orig => @orig_val, :new => @new_val, :field_name => 'Area')
	@changes.concat("- #{@change}<br/>") if @change > ''

	if @orig_member.region_id && @orig_member.region_id != 0
		@orig_val = Region.find(@orig_member.region_id).name
	else
		@orig_val = ''
	end
	if @member.region_id && @member.region_id != 0
		@new_val = Region.find(@member.region_id).name
	else
		@new_val = ''
	end
	@change = add_rem_change(:orig => @orig_val, :new => @new_val, :field_name => 'Region')
	@changes.concat("- #{@change}<br/>") if @change > ''

	if @orig_member.membershiptype_id
		@orig_val = Membershiptype.find(@orig_member.membershiptype_id).name
	else
		@orig_val = ''
	end
	if @member.membershiptype_id
		@new_val = Membershiptype.find(@member.membershiptype_id).name
	else
		@new_val = ''
	end
	@change = add_rem_change(:orig => @orig_val, :new => @new_val, :field_name => 'Membership type')
	@changes.concat("- #{@change}<br/>") if @change > ''

	@groups_orig = Array.new
	@orig_groups_member.each do |gm|
		@groups_orig << Group.find(gm.group_id).name
	end
	
	@groups_member = GroupsMember.find(:all, :conditions => { :member_id => @member.id })
	@groups_new = Array.new
	@groups_member.each do |gm|
		@groups_new << Group.find(gm.group_id).name
	end
	
	@removed_groups = Array.new
	@groups_orig.each do |gm|
		if !@groups_new.include?(gm)
			@removed_groups << gm
		end
	end
	if (@removed_groups.length > 0)
		@changes.concat("- removed from groups #{@removed_groups.join(', ')}<br/>")
	end
	
	@added_groups = Array.new
	@groups_new.each do |gm|
		if !@groups_orig.include?(gm)
			@added_groups << gm
		end
	end
	if (@added_groups.length > 0)
		@changes.concat("- added to groups #{@added_groups.join(', ')}<br/>")
	end

	return @changes
   end
   
   def add_rem_change(args)
	@orig = args[:orig]
	@new = args[:new]
	@field_name = args[:field_name]
	if (@orig || "") != (@new || "")
		if @orig == '' && @new
			return "added #{@field_name} #{@new}"
		elsif @orig && @new == ''
			return "removed #{@field_name} (was #{@orig})"
		else
			return "#{@field_name} changed from #{@orig} to #{@new}"
		end
	else
		return ''
	end
   end

   def note_created_with(args)
	@member = args[:member]
	@creates = ''
	if @member.FirstName > ''
		@creates.concat("- first name is #{@member.FirstName}<br/>")
	end
	if @member.MiddleName > ''
		@creates.concat("- middle name is #{@member.MiddleName}<br/>")
	end
	if @member.LastName > ''
		@creates.concat("- last name is #{@member.LastName}<br/>")
	end
	if @member.email > ''
		@creates.concat("- email is #{@member.email}<br/>")
	end
	@creates.concat("- email address invalid is #{@member.email_invalid}<br/>")
	if @member.website > ''
		@creates.concat("- website is #{@member.website}<br/>")
	end
	if @member.bio > ''
		@creates.concat("- bio is #{@member.bio}<br/>")
	end
	if @member.Photo
		@creates.concat("- photo is <img class='profile' src='#{ApplicationController.new.newzats_members_url+"/uploads/"+File.dirname(@member.Photo)+"/p"+File.basename(@member.Photo)}'/><br/>")
	end
	if @member.addr_1 > ''
		@creates.concat("- Address line 1 is #{@member.addr_1}<br/>")
	end
	if @member.addr_2 > ''
		@creates.concat("- Address line 2 is #{@member.addr_2}<br/>")
	end
	if @member.addr_3 > ''
		@creates.concat("- Address line 3 is #{@member.addr_3}<br/>")
	end
	if @member.addr_4 > ''
		@creates.concat("- Address line 4 is #{@member.addr_4}<br/>")
	end
	if @member.post_code > ''
		@creates.concat("- Post code is #{@member.post_code}<br/>")
	end
	if @member.phone_work > ''
		@creates.concat("- Work phone is #{@member.phone_work}<br/>")
	end
	if @member.phone_home > ''
		@creates.concat("- Home phone is #{@member.phone_home}<br/>")
	end
	if @member.phone_mobile > ''
		@creates.concat("- Mobile phone is #{@member.phone_mobile}<br/>")
	end
	if @member.fax > ''
		@creates.concat("- Fax is #{@member.fax}<br/>")
	end
	if @member.area_id
		@creates.concat("- Area is #{Area.find(@member.area_id).name}<br/>")
	end
	if @member.region_id
		@creates.concat("- Region is #{Region.find(@member.region_id).name}<br/>")
	end
	if @member.membershiptype_id
		@creates.concat("- Membership type is #{Membershiptype.find(@member.membershiptype_id).name}<br/>")
	end
	
	@groups_member = GroupsMember.find(:all, :conditions => { :member_id => @member.id })
	@groups = Array.new
	@groups_member.each do |gm|
		@groups << Group.find(gm.group_id).name
	end
	if (@groups.length > 0)
		@creates.concat("- Groups added to are #{@groups.join(', ')}<br/>")
	end
	
	return @creates
   end
   def create_payment
              @member = Member.find(params[:id])
	      @payment = Payment.new(params[:payment])
		  @payment.member_id = params[:id]
                  @payment.user_id = current_user.id
		  @payment.modification_time = Time.now
                  @payment.save

	      @note = Note.new
		  @note.member_id = params[:id]
		  @note.modification_time = Time.now
                  @note.user_id = current_user.id
                  @note.content = "recorded subs payment $ "+@payment.amount.to_s
                  @note.content += " (partial)" if @payment.partial
                  @note.content += " for "+@payment.year.to_s+" by "+@payment.method
		  @note.save

                  @paid = false
                  if (Payment.find(:all, :conditions => { :member_id => @member.id, :year => Time.now.strftime('%Y'), :partial => false }) != [])
                    @paid = true
                  end

                  respond_to do |format|
                    format.html {
		      flash[:notice] = "Payment saved."
                      redirect_to :action => 'show', :id => @member
                    }
                    format.json {
                      render :json => { 
                        :paid => @paid,
                        :note => {:on => @note.modification_time.in_time_zone("Auckland").strftime("%d-%b-%Y, %I:%M%p"), :by => User.find(@note.user_id).name, :content => @note.content },
                        :payment => { :on => @payment.modification_time.in_time_zone("Auckland").strftime("%d-%b-%Y, %I:%M%p"), :amount => @payment.amount.to_s, :partial => @payment.partial, :year => @payment.year, :by => @payment.method, :recorded_by => User.find(@payment.user_id).name, :id => @payment.id }
                      }
                    }
                  end
   end

   def delete_payment
      @payment = Payment.find(params[:id])
      @payment.delete

      @note = Note.new
      @note.member_id = @payment.member_id
      @note.modification_time = Time.now
      @note.user_id = current_user.id
      @note.content = "removed subs payment $ "+@payment.amount.to_s
      @note.content += " (partial)" if @payment.partial
      @note.content += " for "+@payment.year.to_s+" by "+@payment.method
      @note.save

      @paid = false
      if (Payment.find(:all, :conditions => { :member_id => @payment.member_id, :year => Time.now.strftime('%Y'), :partial => false }) != [])
        @paid = true
      end

      respond_to do |format|
        format.html {
          flash[:notice] = "Payment removed."
          redirect_to :action => 'show', :id => @payment.member_id
        }
        format.json {
          render :json => { :status => :ok, :message => "Payment removed", :paid => @paid, :note => { :on => @note.modification_time.in_time_zone("Auckland").strftime("%d-%b-%Y, %I:%M%p"), :by => User.find(@note.user_id).name, :content => @note.content } }
        }
      end
   end
   def payments
	@member = Member.find(params[:id])
	@payments = Payment.find(:all, :conditions => {:member_id => @member.id}, :order => 'modification_time DESC' )
   end
end
