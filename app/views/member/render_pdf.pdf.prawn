if @document == "label" 

@margins = [0, 10, 0, 24]

pdf.font_size 10

@total_pages = (@members.count / 21.0).ceil

@box_counter = 0

@total_pages.times do |p|

  @page_num = p + 1

  pdf.define_grid(:columns => 3, :rows => 7, :column_gutter => 10)
  
  pdf.grid.rows.times do |i|
    pdf.grid.columns.times do |j|
      b = pdf.grid(i,j)
      pdf.bounding_box b.top_left, :width => b.width, :height => b.height do

        if @box_counter < @members.count
            m = @members[@box_counter]
            @box_text = "\n"+m.first_name + ' ' + m.last_name
            if m.addr_1 > ""
                @box_text += "\n"+m.addr_1
            end
            if m.addr_2 > ""
                @box_text += "\n"+m.addr_2
            end
            if m.addr_3 > ""
                @box_text += "\n"+m.addr_3
            end
            if m.addr_4 > ""
                @box_text += "\n"+m.addr_4
            end
            if m.post_code > ""
                @box_text += "\n"+m.post_code
            end
            pdf.text @box_text
        end
        @box_counter+=1

        #pdf.stroke do
          #pdf.rectangle(pdf.bounds.top_left, b.width, b.height)
        #end

      end
    end
  end

  if @page_num != @total_pages
    pdf.start_new_page(:margin => @margins)
  end


end

elsif @document == "subs"

@time_now = Time.now.in_time_zone("Auckland")
@invoice_count = 0

@members.each do |m|

@invoice_count+=1

pdf.image RAILS_ROOT+"/public/images/newzats_header_subs_form.png", :position => :center
pdf.font_size 12
pdf.text "New Zealand Association of Teachers of Singing Inc.", :align => :center, :style => :bold
pdf.font_size 10 
pdf.text "PO Box 5006, Lambton Quay, Wellington 6011, New Zealand", :align => :center, :style => :bold
pdf.text "<u>admin@newzats.org.nz</u>   Ph: 0800 110 031", :align => :center, :style => :bold, :inline_format => true
pdf.move_down 10

pdf.text @time_now.strftime("%d %B %Y"), :style => :bold
pdf.move_down 10

pdf.text "Invoice # "+@time_now.strftime("%Y")+" - "+"%03d"%@invoice_count, :style => :bold
pdf.move_down 10

pdf.text m.first_name+" "+m.last_name
if m.addr_1 > ""
    pdf.text m.addr_1
end
if m.addr_2 > ""
    pdf.text m.addr_2
end
if m.addr_3 > ""
    pdf.text m.addr_3 
end
if m.addr_4 > ""
    pdf.text m.addr_4
end
if m.post_code > ""
    pdf.text m.post_code
end
pdf.text "Membership # "+m.id.to_s
pdf.move_down 10

pdf.font_size 12 
pdf.text "Invoice – NEWZATS Membership "+@time_now.strftime("%Y"), :align => :center, :style => :bold
pdf.move_down 10

@membership_type = Membershiptype.find(m.membershiptype_id).name
@fee = "$"
if @membership_type == "Full"
    @fee += "100"
elsif @membership_type == "Associate"
    @fee += "90"
end

pdf.dash(5, :space => 0, :phase => 0)
pdf.table [ ["Membership Type","Total Due","Due Date"],[@membership_type,@fee,"30 June "+@time_now.strftime("%Y")] ], :width => 500
pdf.move_down 10

pdf.text "Payment Options:", :style => :bold
pdf.text "*By <b>direct credit</b> to the NEWZATS account 02 0500 0527079 00.", :inline_format => true
pdf.text " Please use your <b>membership number</b> as your reference.", :inline_format => true
pdf.text "*By <b>cheque</b> made out to NEWZATS PO Box 5006, Lambton Quay, Wellington 6011", :inline_format => true
pdf.move_down 10
pdf.move_down 10

pdf.font_size 10
pdf.text "Payments made before 30 April 2012 receive a $5 discount!", :style => :bold
pdf.move_down 10

pdf.text "Please note NEWZATS is not registered for GST.", :style => :bold_italic
pdf.move_down 10

pdf.dash(5, :space => 2, :phase => 0)
pdf.stroke_horizontal_line 0, 500
pdf.dash(5, :space => 0, :phase => 0)
pdf.move_down 10

pdf.text "Remittance to NEWZATS", :align => :center, :style => :bold
pdf.font_size 10
pdf.text "PO Box 5006, Lambton Quay, Wellington 6011", :align => :center
pdf.move_down 10

pdf.text "Please return this section with your payment, <i><b>even if paying by direct credit.</b></i>", :inline_format => true
pdf.text "This will be your receipt, and an opportunity to update your membership details and the NEWZATS website teachers' directory"


pdf.text "Membership Number: "+m.id.to_s, :align => :right
pdf.text m.first_name+" "+m.last_name
if m.addr_1 > ""
    pdf.text m.addr_1
end
if m.addr_2 > ""
    pdf.text m.addr_2
end
if m.addr_3 > ""
    pdf.text m.addr_3 
end
if m.addr_4 > ""
    pdf.text m.addr_4
end
if m.post_code > ""
    pdf.text m.post_code
end
pdf.move_down 10

pdf.font_size 8
pdf.text "* Payments made before 30 April "+@time_now.strftime("%Y")+" receive a $5 discount", :align => :center, :style => :bold
pdf.font_size 10
pdf.text "I have paid by direct credit   Y/N          Amount Paid: ______     Date Paid: ______"
pdf.move_down 10

pdf.text "I consent to having my name and address in the <u>NEWATS website teachers’ directory</u>.  Y/N", :style => :bold, :inline_format => true

if @invoice_count < @members.count
    pdf.start_new_page
end

end


end
