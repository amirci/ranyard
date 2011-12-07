class EventsPage < BasePage
  
  def list
    all(:css, 'table.day').map do |table|
      table.all(:css, 'tr.event').map do |tr|
        cells = tr.all(:css, 'td')
        {
          slot: TimeSlot.parse(cells[0].text),
          session: cells[1].text,
          room: cells[2].text,
          main: cells[3].text.strip == 'Y',
          custom: cells[4].text
        }
      end
    end
  end

  def sample_session
    Rails.logger.debug { "**** Sampling a session from #{list}" }
    list.
      sample.
      delete_if { |row| row[:session].nil? || row[:session].empty? }.
      sample[:session]
  rescue
    raise Exception.new("Can't find a sample session because there are no rows to sample!" )
  end
  
  def edit(session_title)
    find_row_for(session_title).click_link('Edit')
    EventEditPage.new
  end

  def delete(session_title)
    evaluate_script('window.confirm = function() { return true; }')
    find_row_for(session_title).click_button('Delete Event')
  end
  
  private
    def find_row_for(session_title)
      escaped = session_title.gsub("'", "\\'")
      find(:xpath, "//td[.='#{escaped}']/..")
    end
    
end