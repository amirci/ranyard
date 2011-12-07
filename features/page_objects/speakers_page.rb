class SpeakersPage < BasePage
  
  def list
    all(:css, "li.speaker").map do |li|
      { name: li.find(".info .name").text, 
        website: find_icon(li, "website"),
        blog: find_icon(li, "blog"),
        twitter: find_icon(li, "twitter"),
        email: find_icon(li, "email"),
        bio: li.find(".bio").text,
        picture: li.find('.pic')[:src].gsub("/assets/speakers/", ""),
        location: li.find('.location').text.strip
      }
    end
  end
  
  def open_session(session)
    click_link(session.title)
  end
  
  def new_speaker
    click_link('New Speaker')
    SpeakerEditPage.new
  end
  
  def edit(speaker)
    find(:css, "#speaker_#{speaker.id}").click_link('Edit')
    SpeakerEditPage.new
  end
  
  def can_create?
    has_content?('New Speaker')
  end
    
  def can_edit?
    has_content?('Edit')
  end

  def can_delete?
    has_content?('Delete')
  end
  
  private
    def find_icon(li, css_path)
      found = li.all(:css, "a.#{css_path}")
      found.empty? ? nil : found.first[:href].
                          gsub("http://", "").
                          gsub("mailto:", "").
                          gsub("www.twitter.com/", "")
    end
end