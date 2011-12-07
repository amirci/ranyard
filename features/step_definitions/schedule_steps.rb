Then /^I should not be able to edit the schedule$/ do
  schedule_po.can_edit?.should be_false
end

Given /^I'm editing the schedule$/ do
  Given %Q{I'm logged in as an admin}
  visit schedule_path
  schedule_po.edit
end

When /^I delete event with session "([^"]*)"$/ do |session_title|
  events_po.delete(session_title)
end

Then /^I should get the response with events for day (\d+)$/ do |day|
  Then(%Q{the JSON at "day" should be #{events_for_day(day.to_i).to_json}})
end

Then /^I should see the schedule of the(?: active)? conference$/ do
  schedule_po.calendars.should =~ conference_schedule
end

When /^I modify an event to be at "([^"]*)"$/ do |time_slot|
  @session_title = events_po.sample_session
  events_po.
    edit(@session_title).
    update_time_slot(time_slot).
    save  
end

Then /^the modified event should be at "([^"]*)"$/ do |time_slot|
  schedule_po.time_slot(@session_title).should == TimeSlot.parse(time_slot)
end

When /^I delete an event$/ do
  @session_title = events_po.sample_session
  events_po.delete(@session_title)
end

Then /^the deleted event should not be in the schedule$/ do
  schedule_po.sessions.should_not include(@session_title)
end

Then /^the response should be the schedule for the default conference$/ do
  parsed_schedule_json_response.should == json_schedule_src
end

Then /^the response should be day "([^"]*)" for the default conference$/ do |day|
  last_json.should be_json_eql json_day_src(day.to_i).to_json
end
