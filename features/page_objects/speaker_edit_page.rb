class SpeakerEditPage < BasePage
  
  def load(attrib)
    attrib.each_pair { |k, v| fill_in(k.capitalize, with: v) } 
    self
  end

  def values
    field_names.inject({}) { |map, f| map[f] = find(:css, "#speaker_#{f}").value; map }
  end
  
  def save
    click_button("Save")
    visit '/speakers'
    self
  end

  private 
    def field_names
      [:name, :email, :location, :twitter, :blog, :website, :bio, :picture]
    end
end