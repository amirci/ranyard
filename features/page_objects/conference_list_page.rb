class ConferenceListPage < BasePage
  
  def list
    all(:css, "#conferences #list tr")
      .drop(1) #drop the header
      .map do |r|
        values = r.all(:css, 'td').collect { |node| node.text }
        { name: values[0], 
          start: Date.parse(values[1]), 
          finish: Date.parse(values[2]), 
          active: values[3] == 'active',
          subdomain: values[4] == "" ? nil : values[4],
          venue: values[5],
          city: values[6] }
    end
  end
  
  def new_conference
    click_link('New Conference')
    ConferenceEditPage.new
  end
  
end