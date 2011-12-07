Given /^I have the following speakers:$/ do |table|
  table.hashes.each { |attrib| Speaker.create(attrib) }
end

Given /^I have the following speakers for "(.+)":$/ do |conf, table|
  table.hashes.each { |attrib| Speaker.create(attrib) }
end
 
Then /^I should see speaker info:$/ do |table|
  table.hashes.each do |row|
    within("#speaker_#{row['id']}") do
      Then %Q{I should see "#{row['name']}"}
      Then %Q{I should see "#{row['bio']}"}
      Then %Q{I should see "#{row['location']}"}
      page.should have_xpath(".//img[@src='/assets/#{row['picture']}']")
    end
  end
end

Then /^I should see the speaker icons:$/ do |table|
  table.hashes.each do |row|
    id = row['id']
    within("#speaker_#{id}") do
      page.should have_xpath(".//a[@href='mailto:#{row['email']}']") 
      %w{website blog twitter}.each { |field| page.should have_xpath(".//a[@href='#{row[field]}']") }
    end
  end
end

Then /^I should see the speaker sessions:$/ do |table|
  table.hashes.each do |row|
    within("#speaker_#{row['id']}") do
      Then %Q{I should see "#{row['title']}"}
      Then %Q{I should see "#{row['day']}, #{row['time']}, room #{row['room']}"}
    end
  end
end

Given /^I have a speaker that has no picture$/ do
  Fabricate(:speaker, picture: nil)
end

Then /^the missing picture should be shown for the speaker$/ do
  page.should have_css('img.pic', src: 'speakers/missing.jpg')
end

Then /^I should see all the active conference speakers listed$/ do
  expected = active_conference.speakers.map { |s| speaker_values(s) }
  speakers_po.list.should =~ expected
end

Then /^I should not be able to create a new speaker$/ do
  speakers_po.can_create?.should be_false
end

Then /^I should not be able to edit any speakers$/ do
  speakers_po.can_edit?.should be_false
end

Then /^I should not be able to delete any speakers$/ do
  speakers_po.can_delete?.should be_false
end

When /^I open the session for a speaker$/ do
  @speaker = active_conference.speakers.first
  @session = @speaker.sessions.first
  speakers_po.open_session(@session)
end

When /^I go back to the speaker list$/ do
  session_show_po.back_to_speakers
end

Then /^the response should be all the speakers for the default conference$/ do
  expected = parse_json(expected_json(active_conference.speakers))
  parse_json(last_json)['speakers'].should =~ expected['speakers']
end

Then /^the response should be the speaker with id "([^"]*)"$/ do |id|
  last_json.should be_json_eql expected_json(Speaker.find(id.to_i))
end

When /^I create a new speaker$/ do
  @new_speaker = Fabricate.attributes_for(:speaker)
  speakers_po.
    new_speaker.
    load(@new_speaker).
    save
end

When /^I edit a speaker$/ do
  speakers_po.edit(active_conference.speakers.first)
end

Then /^the new speaker should appear in the speakers page$/ do
  speakers_po.list.should include(@new_speaker.symbolize_keys)
end

Then /^the speaker information should be loaded in the form$/ do
  speaker_edit_po.values.should == speaker_values(active_conference.speakers.first)
end
