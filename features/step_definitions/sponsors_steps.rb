When /^I query the API for sponsors$/ do
  When %Q{I call API "/sponsors.json"}
end

Then /^I should get all the sponsors listed as JSON(?: for the active conference)?$/ do
  last_json.should be_json_eql conference_sponsors_json
end
