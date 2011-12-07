class EventEditPage < BasePage
  
  def update_time_slot(time_slot)
    ts = TimeSlot.parse(time_slot)

    # start time
    @session.select(ts.start.strftime('%H'), from: 'event_start_4i')
    @session.select(ts.start.strftime('%M'), from: 'event_start_5i')
    
    # end time
    @session.select(ts.finish.strftime('%H'), from: 'event_finish_4i')
    @session.select(ts.finish.strftime('%M'), from: 'event_finish_5i')
                                    
    self
  end
  
  def save
    click_button("Update Event")
    self
  end
  
end
    