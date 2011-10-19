@margins = [0, 10, 0, 24]
#pdf.start_new_page(:margin => @margins)

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

        pdf.stroke do
          #pdf.rectangle(pdf.bounds.top_left, b.width, b.height)
        end

      end
    end
  end

  if @page_num != @total_pages
    pdf.start_new_page(:margin => @margins)
  end


end

