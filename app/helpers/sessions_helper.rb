module SessionsHelper
  include ActsAsTaggableOn::TagsHelper

  def attending_stats_if_admin(session)
    content_tag(:span, session.planning_to_attend, class: 'attending_stats') if current_user
  end
  
  def favourite(session, options = {})
    classes = 'btn ' + (options[:class] || '') 
    button_to('Star It!', {action: 'attending', id: session.id}, class: classes)
  end

  def speakers(session = nil)
    session ||= @session
    names = session.speakers.collect { |sp| sp.name }.join(', ')
    names.empty? ? 'TBD' : names
  end
  
  def tags(session = nil)
    session ||= @session
    tagged_as = session.tags.map do |t|
      link_to(t.name.upcase, '#', class: 'tags')
    end.reduce(:+)
    tagged_as == "" ? 'TBD' : tagged_as
  end
  
  def abstract(session = nil)
    session ||= @session
    markdown_parse(session.abstract).html_safe
  end
  
  def session_buttons(session = nil)
    session ||= @session
    content_tag(:p) do
      edit_link(session).html_safe + 
      back_link(session)
    end
  end
  
  def schedule(session = nil)
    session ||= @session
    return unless session.event
    content_tag(:div, event_format(session.event), class: 'schedule')
  end
  
  private
    def back_link(session)
      link_to('Back to sessions', sessions_path) +
      ' | ' +
      link_to('Back to speakers', speakers_path(anchor: "session_#{session.id}")) +
      ' | ' +
      link_to('Back to schedule', schedule_path(anchor: "session_#{session.id}")) 
    end
  
    def edit_link(session)
      current_user ? link_to('Edit', edit_session_path(session)) + "|" : ""
    end
end
