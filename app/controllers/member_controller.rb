class MemberController < ApplicationController
   def email
      @members = Member.find(:all, :conditions => ["deleted is NULL AND (email_invalid is NULL OR email_invalid = 'f') AND email > ''"])
   end
   def search
	  @term = params[:term]
	  @members = Member.find(:all, :conditions => [
		"deleted is NULL AND 
		(first_name like ? OR
		 last_name like ? OR
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
			"%"+@term+"%"
		])
   end
   def notes
		@member = Member.find(params[:id])
		@notes = Note.find(:all, :conditions => {:member_id => @member.id}, :order => 'modification_time DESC' )
   end
   def list
      @members = Member.find(:all, :conditions => ["deleted is NULL"])
   end
   def show
      @member = Member.find(params[:id])
	  if (@member.deleted)
	    flash[:notice] = "Error: This member (id #{@member.id}) has been deleted"
		redirect_to :action => 'list'
	  end
	  @has_any_address
	  if (@member.addr_1 > '' || @member.addr_2 > '' || @member.addr_3 > '' || @member.addr_4 > '' || @member.post_code > '')
		@has_any_address = 'true'
	  end
	  @has_any_phone
	  if (@member.phone_work > '' || @member.phone_home > '' || @member.phone_mobile > '' || @member.fax > '')
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
   end
   def new
      @member = Member.new
	  @groups = Group.find(:all)
	  @regions = Region.find(:all)
	  @membershiptypes = Membershiptype.find(:all)
   end
   def create
      @member = Member.new(params[:member])
	  @groups = Group.find(:all)
	  @regions = Region.find(:all)
	  @membershiptypes = Membershiptype.find(:all)

      if @member.save
	      @note = Note.new
		  @note.member_id = @member.id
		  @note.content = note_created_with(:member => @member)
		  @note.modification_time = Time.now
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
	  @regions = Region.find(:all)
	  @membershiptypes = Membershiptype.find(:all)
	  @selected_region
	  if @member.region_id
		@selected_region = Region.find(@member.region_id)
	  end
	  @selected_membershiptype
	  if @member.membershiptype_id
		@selected_membershiptype = Membershiptype.find(@member.membershiptype_id)
	  end
   end
   def update
      @member = Member.find(params[:id])
	  @orig_member = Member.find(params[:id])
      if @member.update_attributes(params[:member])
		  @note = Note.new
		  @note.member_id = @member.id
		  @note.content = note_what_has_changed(:orig_member => @orig_member, :member => @member)
		  @note.modification_time = Time.now
		  @note.save
		  
		 flash[:notice] = "Successfully saved."
         redirect_to :action => 'show', :id => @member
      else
	  	  @groups = Group.find(:all)
		  @regions = Region.find(:all)
		  @membershiptypes = Membershiptype.find(:all)
         render :action => 'edit'
      end
   end
   def delete
      @member = Member.find(params[:id])
	  @member.deleted = true
	  @member.save
      redirect_to :action => 'list'

   end
   
   def note_what_has_changed(args)
    @orig_member = args[:orig_member]
	@member = args[:member]
	@changes = 'member details changed:<br/>'
	if @orig_member.first_name != @member.first_name
		@changes.concat("- first name from #{@orig_member.first_name} to #{@member.first_name}<br/>")
	end
	if @orig_member.middle_name != @member.middle_name
		@changes.concat("- middle name from #{@orig_member.middle_name} to #{@member.middle_name}<br/>")
	end
	if @orig_member.last_name != @member.last_name
		@changes.concat("- last name from #{@orig_member.last_name} to #{@member.last_name}<br/>")
	end
	if @orig_member.email != @member.email
		@changes.concat("- email from #{@orig_member.email} to #{@member.email}<br/>")
	end
	if @orig_member.email_invalid != @member.email_invalid
		@changes.concat("- email address invalid from #{@orig_member.email_invalid} to #{@member.email_invalid}<br/>")
	end
	if @orig_member.addr_1 != @member.addr_1
		@changes.concat("- Address line 1 from #{@orig_member.addr_1} to #{@member.addr_1}<br/>")
	end
	if @orig_member.addr_2 != @member.addr_2
		@changes.concat("- Address line 2 from #{@orig_member.addr_2} to #{@member.addr_2}<br/>")
	end
	if @orig_member.addr_3 != @member.addr_3
		@changes.concat("- Address line 3 from #{@orig_member.addr_3} to #{@member.addr_3}<br/>")
	end
	if @orig_member.addr_4 != @member.addr_4
		@changes.concat("- Address line 4 from #{@orig_member.addr_4} to #{@member.addr_4}<br/>")
	end
	if @orig_member.post_code != @member.post_code
		@changes.concat("- Post code from #{@orig_member.post_code} to #{@member.post_code}<br/>")
	end
	if @orig_member.phone_work != @member.phone_work
		@changes.concat("- Work phone from #{@orig_member.phone_work} to #{@member.phone_work}<br/>")
	end
	if @orig_member.phone_home != @member.phone_home
		@changes.concat("- Home phone from #{@orig_member.phone_home} to #{@member.phone_home}<br/>")
	end
	if @orig_member.phone_mobile != @member.phone_mobile
		@changes.concat("- Mobile phone from #{@orig_member.phone_mobile} to #{@member.phone_mobile}<br/>")
	end
	if @orig_member.fax != @member.fax
		@changes.concat("- Fax from #{@orig_member.fax} to #{@member.fax}<br/>")
	end

	return @changes
   end

   def note_created_with(args)
	@member = args[:member]
	@creates = 'member created with:<br/>'
	if @member.first_name
		@creates.concat("- first name is #{@member.first_name}<br/>")
	end
	if @member.middle_name
		@creates.concat("- middle name is #{@member.middle_name}<br/>")
	end
	if member.last_name
		@creates.concat("- last name is #{@member.last_name}<br/>")
	end
	if @member.email
		@creates.concat("- email is #{@member.email}<br/>")
	end
	if @member.email_invalid
		@creates.concat("- email address is #{@member.email_invalid}<br/>")
	end
	if @member.addr_1
		@creates.concat("- Address line 1 is #{@member.addr_1}<br/>")
	end
	if @member.addr_2
		@creates.concat("- Address line 2 is #{@member.addr_2}<br/>")
	end
	if @member.addr_3
		@creates.concat("- Address line 3 is #{@member.addr_3}<br/>")
	end
	if @member.addr_4
		@creates.concat("- Address line 4 is #{@member.addr_4}<br/>")
	end
	if @member.post_code
		@creates.concat("- Post code is to #{@member.post_code}<br/>")
	end
	if @member.phone_work
		@creates.concat("- Work phone changed is #{@member.phone_work}<br/>")
	end
	if @member.phone_home
		@creates.concat("- Home phone is #{@member.phone_home}<br/>")
	end
	if @member.phone_mobile
		@creates.concat("- Mobile phone is #{@member.phone_mobile}<br/>")
	end
	if @member.fax
		@creates.concat("- Fax changed is #{@member.fax}<br/>")
	end
	return @creates
   end
end
