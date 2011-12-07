module SpeakersHelper

  def actions(speaker)
    return unless current_user 
    content_tag(:span, nil, class: 'modify') do
      link_to('[Edit]', edit_speaker_path(speaker)) +
      button_to("Delete Speaker", 
               { :action => "destroy", :id => speaker.id }, 
               {:confirm => "Are you sure?", :method => :delete})
    end
  end
  
  def sort_by_last_name(speakers)
    speakers.sort_by do |s| 
      names = s.name.split(' ')
      names.empty? ? '' : names.last
    end
  end
  
  def picture(speaker)
    picture = speaker.picture ? speaker.picture.downcase : 'missing.jpg'
    image_tag("speakers/#{picture}", class: 'pic', alt: speaker.name)
  end
  
  def name(speaker)
    content_tag(:h2, speaker.name.html_safe, class: 'name') + 
    location(speaker) + 
    speaker.sessions.map { |s| link_to("", "*", name: "session_#{s.id}") }.reduce(:+)
  end

  def location(speaker)
    speaker.location ? content_tag(:em, " #{speaker.location}", class: 'location') : ""
  end

  def icons(speaker)
    content_tag(:ol, class: 'icons') do
      [:email, :blog, :website, :twitter].
        map     { |k| list_item(speaker, k) }.
        reject  { |li| li.nil? }.
        reduce(:+)
    end
  end

  def bio(speaker)
    content_tag(:div, markdown_parse(speaker.bio).html_safe, class: 'bio') unless speaker.bio.nil?
  end
  
  def sessions(speaker)
    return if speaker.sessions.empty?
    content_tag(:dl, nil, class: 'sessions') do
      speaker.sessions.collect do |s| 
        content_tag(:dt, "Session:") +
        content_tag(:dd, link_to(session_schedule(s), s))
      end.reduce(:+)
    end
  end
  
  private
    def session_schedule(s)
      return s.title unless s.event
      "#{s.title} (#{event_format(s.event)})"
    end
    
    def list_item(speaker, kind)
      url = speaker.send(kind)
    
      return nil if url.nil? || url == ""
    
      url = "http://www.twitter.com/#{url}" if kind == :twitter
      url = "mailto:#{url}" if kind == :email
      url = "http://#{url}" if kind == :blog || kind == :website
    
      content_tag(:li) do
        link_to(url, target: "blank", class: kind) do
          image_tag("icon_#{kind}.gif")
        end
      end
    end
end
