module ContentHelper
  
  def show_content_field(field, builder)
    if field.type.kind_of? String
      if @content.class.text_area_fields.include?(field.name.to_sym)
        builder.text_area field.name
      else
        builder.text_field field.name
      end
    elsif field.type.kind_of? Time
      builder.datetime_select(field.name, 
                              :time_separator => "<span class=\"separator\">:</span>".html_safe, 
                              :date_separator => "<span class=\"separator\">&mdash;</span>".html_safe, 
                              :datetime_separator => "",
                              :include_blank => (field.name != "publish_date")) + content_tag(:span, "UTC", :class => "time-zone separator")
    elsif field.type.kind_of? Boolean
      builder.check_box field.name
    elsif field.type == Integer
      builder.select(field.name, options_for_select((Content::MIN_PRIORITY..Content::MAX_PRIORITY).to_a, @content.send(field.name) || Content::DEFAULT_PRIORITY))
    else
      raise "Unknown type #{field.type} - #{field.type.inspect} || #{field.inspect}"
    end
  end
  
  def show_content_label(field, builder)
    builder.label field.name
  end
  
  
end
