module ApplicationHelper

  def body_style
    page_style = controller_name == 'pages' ? " #{params[:id]}" : ''
    controller_name + page_style
  end
  
  def markdown_parse(str)
    bc = BlueCloth.new(str)
    bc.to_html
  end

  def admin_stylesheet
    subdomain = active_conference.subdomain || 'east'
    stylesheet_link_tag "application_#{subdomain}", :debug => Rails.env.development?
  end

  def admin_logo
    if active_conference.subdomain == 'west'
      image_tag('west/logo_prairie_dev_con_west.png') +
      image_tag('west/header_date.png', :border=>0, :class=>'dates')
    else
      image_tag 'wpg/wordmark.jpg'
    end
  end
  
  def content_detail_switch
    link_to('complete', '#', class: 'cmd-high-detail selected') +
    ' | ' +
    link_to('compact', '#', class: 'cmd-low-detail') 
  end
  
  private
    def event_format(e)
      "#{e.start.strftime('%a, %H:%M')}, room #{e.room.name}"
    end
end
