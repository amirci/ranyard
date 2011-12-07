module ApplicationHelper

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
  private
    def event_format(e)
      "#{e.start.strftime('%a, %H:%M')}, room #{e.room.name}"
    end
end
