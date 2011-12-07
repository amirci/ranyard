Given /^I have the following sessions:$/ do |table|
  table.hashes.each do |attrib| 
    speakers = attrib[:speaker]
    session = Session.create(attrib.delete_if { |k, v| k == 'speaker' })
    speakers.split(', ').each do |sp|
      speaker = Speaker.find_or_create_by_name(sp.strip)
      speaker.sessions << session
    end
  end
end

Given /^I have (\d+) sessions starting with "(.+)"$/ do |count, prefix|
  (1..count.to_i).each do |i|
    s = Speaker.create(name: "Speaker #{i}")
    s.sessions.create(title: "#{prefix}#{i}", abstract: 'Very nice session!')
  end
end

Given /^I have the following sessions schedule:$/ do |table|
  table.hashes.each do |attrib|
    s = Session.find_by_title(attrib['title'])
    r = Room.create(name: attrib['room'])
    e = r.events.create(start: attrib['start'], finish: attrib['finish'])
    e.session = s
  end
end

Then /^I should see a '(.*?)' with the following tags:$/ do |tag_container_selector, table|
  tags_to_find = table.rows.map {|row| row[0]}
  within(tag_container_selector) do
    tags_to_find.each do |tag|
      Then "I should see \"#{tag}\""
    end
  end
end

When /^I vote (up|down) '(.*?)'$/ do |vote,session_title|
  s = Session.find_by_title(session_title)
  page.find("#session#{s.id} .rating .#{vote}").click
end

When /^I filter by '(.*?)'$/ do |tag_name|
  with_scope 'the tag list' do
    page.find(:css, "li", :text => tag_name).click
  end
end

When /^I clear the filter$/ do
  with_scope 'the tag list' do
    page.find(:css, "li", text: 'See All Sessions').click
  end
end

Then /^the session "([^\"]+)" should( not)? be visible$/ do |text, visible|
  found = page.all(:css, "li h3", visible: visible.nil? || visible.empty?, content: text)             
  assert !found.empty?, "The session with title '#{text}' should#{visible} be visible in the page"
end


Then /^the session (\d+) should should have (\d+) people attending$/ do |id, people|
  Session.find(id).planning_to_attend.should == people.to_i
end

Then /^I should see the schedule for each session:$/ do |table|
  table.hashes.each do |h|
    s = Session.find_by_title(h['title'])
    with_scope "the session #{s.id}" do
      Then %Q{I should see "#{h['room']}"}
      Then %Q{I should see "#{h['time']}"}
      Then %Q{I should see "#{h['day']}"}
    end
  end
end

Then /^I should see the attendance report with:$/ do |table|
  fields = %w(title speaker abstract attending)
  table.hashes.each do |row|
    fields.each { |f| page.should have_content(row[f]) }
  end
end

Then /^I should see the session information$/ do
  session_show_po.info.should == {title: @session.title, abstract: @session.abstract}
end


When /^I add a new session$/ do
  @new_session = Fabricate.build(:session_loaded, conference: active_conference)
  @new_session.speakers = [active_conference.speakers.first]
  sessions_po.
    new_session.
    load(@new_session).
    save
end

Then /^the new session should appear in the sessions page$/ do
  sessions_po.list.should include session_values(@new_session)
end

When /^I edit a session$/ do
  sessions_po.edit(active_conference.sessions.first)
end

Then /^the session information should be loaded in the form$/ do
  session_edit_po.values.should == session_values(active_conference.sessions.first)
end

Given /^I delete a session$/ do
  @deleted_session = active_conference.sessions.first
  sessions_po.delete(@deleted_session)
end

Then /^the session should not appear in the sessions list$/ do
  sessions_po.list.should_not include session_values(@deleted_session)
end

When /^modify the session values$/ do
  updated_session = active_conference.sessions.first
  updated_session.update_attributes(Fabricate.attributes_for(:session_loaded))
  updated_session.speakers << active_conference.speakers.last
  session_edit_po.load(updated_session).save
end

Then /^the updated session should appear in the sessions list$/ do
  sessions_po.list.should include session_values(active_conference.sessions.first)
end

Then /^I should see all the active conference sessions listed$/ do
  sessions_po.list.should =~ session_values(active_conference.sessions)
end

When /^I open the attendance report$/ do
  sessions_po.open_attendance_report
end

Then /^I should see the attendance information for the sessions$/ do
  attendance_report_po.list.should =~ attendance_report
end

Then /^the response should be all the sessions for the default conference$/ do
  parsed_sessions_json_response.should == json_sessions_src
end

Then /^the response should be the session with id "([^"]*)"$/ do |id|
  parsed_session_json_response.should == json_session_src(id.to_i)
end

Then /^I should see the list of tags for all the sessions$/ do
  sessions_po.filters.should =~ session_filters
end

When /^I apply the session filter$/ do
  sessions_po.apply_filter(sessions_po.filters.first)
end

Then /^I should see only the sessions with the filtered tag$/ do
  sessions_po.list.should =~ filtered_sessions(sessions_po.filters.first)
end

Then /^I should not be able to create a new session$/ do
  sessions_po.can_create?.should be_false
end

Then /^I should not be able to edit any sessions$/ do
  sessions_po.can_delete?.should be_false
end

Then /^I should not be able to delete any sessions$/ do
  sessions_po.can_edit?.should be_false
end