class HomePage < BasePage
  
  def conference_details
    details = all(:css, '#hd ul.detail li')
    { dates: details[0].text, venue: details[1].text, city: details[2].text }
  end

end
