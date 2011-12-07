class SessionEditPage < BasePage
  
  def load(session)
    fill_in('Title', with: session.title)
    fill_in('Abstract', with: session.abstract)
    session.speakers.each { |sp| check(sp.name) }
    fill_in('Tags', with: session.tag_list)
    self
  end
  
  def values
    {
      title: find(:css, "#session_title").value,
      abstract: find(:css, '#session_abstract').value,
      speakers: all(:css, '.check_boxes').
                    select { |cb| cb.checked? }.
                    map { |cb| Speaker.find(cb.value).name },
      tags: find(:css, '#session_tag_list').value.split(',').map { |s| s.strip.upcase }.sort
    }
  end
  
  def save
    click_button("Save")
    visit "/sessions"
    self
  end

end