Given /^the data has been modified on "([^"]*)"$/ do |modified|
  s = Fabricate(:session)
  s.update_attribute(:updated_at, DateTime.parse(modified))
end

When /^I query the API to get the last update$/ do
  Given %Q{I call API "/last_update.json"}
end

Then /^I JSON API last update should be "([^"]*)"$/ do |expected|
  json = { last_update: DateTime.parse(expected).strftime('%Y-%m-%dT%H:%M:%SZ') }.to_json
  last_json.should be_json_eql json
end
