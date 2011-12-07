Given /^I have a conference with (?:a code of|subdomain) "([^"]*)"$/ do |subdomain|
  create_schedule(Fabricate(:conf_loaded, subdomain: subdomain))
end

Given /^I have the following conferences:$/ do |table|
  table.hashes.each { |conf| Conference.create(conf) }
end

Given /^I have some conferences loaded( with schedule)?$/ do |schedule|
  west = Fabricate(:conf_loaded, subdomain: 'west')
  default = Fabricate(:conf_loaded, subdomain: nil)
  create_schedule(west, default) if schedule
end
  
Given /^I have the following conferences for "(.+)":$/ do |conf, table|
  table.hashes.each { |conf| Conference.create(conf) }
end

Given /^I have a conference with a name of "([^"]*)" hosted at the root domain$/ do |name|
  Fabricate(:conference, :name => name, :subdomain => nil)
end

When /^I visit the root domain$/ do
  visit root_url
end

When /^I visit the subdomain "([^"]*)"$/ do |subdomain|
  visit root_url(subdomain: subdomain)
end

Then /^I should see the home page for the "([^"]*)" conference$/ do |key|
   conf = Conference.find_by_subdomain(key) || Conference.find_by_name(key)
   home_po.conference_details.should eq conference_details(conf)
end

Then /^I should see all the conferences listed$/ do
  conference_list_po.list.should == map_attributes(Conference.all)
end

Then /^the conference fields should be loaded$/ do
  conference_edit_po.fields.should == map_attributes(Conference.first)
end

When /^I edit the first conference$/ do
  click_link("Edit")
end
  
When /^I create a new conference$/ do
  @new_conf = Fabricate.attributes_for(:conference).symbolize_keys
  conference_list_po.
    new_conference.
    load(@new_conf).
    save
end
  
When /^I save new conference data$/ do
  @new_conf = Fabricate
                .attributes_for(:conference, subdomain: nil)
                .symbolize_keys
  conference_edit_po.load(@new_conf).save
  conference_edit_po.notification.should == "Conference was successfully updated."
end

Then /^the conference should be updated$/ do
  visit conferences_path
  conference_list_po.list.should include @new_conf
end

Then /^the new conference should appear in the conference listing$/ do
  Given %Q{the conference should be updated}
end


