module ContentHelper
  
  def show_content_field(field, builder)
    case field.type.new
    when String
      if @content.class.text_area_fields.include?(field.name.to_sym)
        builder.text_area field.name
      else
        builder.text_field field.name
      end
    when Time
      builder.datetime_select(field.name, 
                              :time_separator => "<span class=\"separator\">:</span>".html_safe, 
                              :date_separator => "<span class=\"separator\">&mdash;</span>".html_safe, 
                              :datetime_separator => "",
                              :include_blank => (field.name != "publish_date")) + content_tag(:span, "UTC", :class => "time-zone separator")
    when Boolean
      builder.check_box field.name
    end
  end
  
  def show_content_label(field, builder)
    builder.label field.name
  end
  
  
end
