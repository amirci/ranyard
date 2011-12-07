class SessionsPage < BasePage
  
  def list 
    all(:css, "li.session", visible: true).map do |li|
      {
        title: li.find(:css, '.title a').text,
        abstract: li.find(:css, '.abstract').text,
        speakers: li.find(:css, '.speakers').text.split(',').map(&:strip),
        tags: find_tags(li)
      }
    end
  end
  
  def new_session
    click_link('New Session')
    SessionEditPage.new
  end
  
  def edit(session)
    find(:css, "#session_#{session.id}").click_link('Edit')
    SessionEditPage.new
  end
  
  def delete(session)
    evaluate_script('window.confirm = function() { return true; }')
    find(:css, "#session_#{session.id}").click_button('Delete')
    self
  end
  
  def open_attendance_report
    click_link('Attendance')
    AttendanceReportPage.new
  end
  
  def filters
    all(:css, '#tag-list li').drop(1).map { |li| li.text }
  end
  
  def apply_filter(filter)
    find(:css, '#tag-list li', text: filter).click
  end
  
  def can_create?
    has_content?('New Session')
  end
    
  def can_edit?
    has_content?('Edit')
  end

  def can_delete?
    has_content?('Delete')
  end
  
  private
  
    def find_tags(li)
      (li.
        find(:css, '.tags').
        text.
        split(',') - ['TBD']).
        map { |s| s.strip.upcase }.
        sort
    end
end