class ConferenceEditPage < BasePage

  def fields
    { name: find_field("Name").value, 
      start: find_date('conference_start'),
      finish: find_date('conference_finish'),
      city: find_field('City').value,
      venue: find_field('Venue').value,
      subdomain: find_field('Subdomain').value,
      active: find_field('Active').value == "1" }
  end
  
  def load(values)
    values = values.symbolize_keys
    fill_in("Name", :with => values[:name])
    fill_in("City", :with => values[:city])
    fill_in("Venue", :with => values[:venue])
    fill_in("Subdomain", :with => values[:subdomain] || '') 
    fill_in_date("conference_start", values[:start])
    fill_in_date("conference_finish", values[:finish])
    set_check('Active', values[:active])
    self
  end
  
  def save
    click_button("Save")
    self
  end
  
  def notification
    find(:css, "#notice").text
  end
  
end