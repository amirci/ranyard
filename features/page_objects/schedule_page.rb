class SchedulePage < BasePage
  
  def calendars
    all(:css, '#calendar').map { |t| { header: calendar_header(t), rows: calendar_rows(t) } }
  end

  def sessions
    calendars.map { |c| c[:rows].drop(1).reject { |c| c == '-' } }.flatten
  end
  
  def can_edit?
    has_content?("Edit Schedule")
  end
  
  def edit
    click_link('Edit Schedule')
    EventsPage.new
  end
  
  def time_slot(session_title)
    return nil if calendars.empty?
    includes_title = ->(s) { s.include?(session_title) }
    matching_row = ->(r) { r.one?(&includes_title) }
    all_rows = calendars.map { |c| c[:rows] }.flatten(1)
    found = all_rows.find(&matching_row)
    TimeSlot.parse(found[0]) rescue nil
  end
  
  private
    def calendar_header(t)
      t.all(:css, 'th').collect { |node| node.text }
    end
    
    def calendar_rows(t)
      t.all(:css, "tbody>tr").map do |row|
        cells = row.all(:css, 'td').map { |node| node.text }
        cells[0] = cells[0].gsub('to', ' - ')
        cells
      end
    end

end
