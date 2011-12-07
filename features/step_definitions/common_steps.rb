When /^(?:|I )call (.+)$/ do |page_name|
  visit path_to(page_name)
end

Then /^I should see the following (.+):$/ do |title, table|
  table.hashes.each do |resource| 
    resource.each { |k, v| Then("should see \"#{v}\"") }
  end
end

Given /^I confirm the confirmation dialog$/ do
  page.evaluate_script('window.confirm = function() { return true; }')
end

Then /^I should have the following mails:$/ do |table|
  table.rows.each do |row|
    row.each { |link| page.should have_xpath("//a[@href='mailto:#{link}']") }
  end
end

Then /^I should not have the following mails:$/ do |table|
  table.rows.each do |row|
    row.each { |link| page.should_not have_xpath("//a[@href='mailto:#{link}']") }
  end
end

Then /^I should not have the following links:$/ do |table|
  table.rows.each do |links|
    links.each { |link| page.should_not have_xpath("//a[@href='#{link}']") }
  end
end

Then /^I should have the following links:$/ do |table|
  table.rows.each do |links|
    links.each { |link| page.should have_xpath("//a[@href='#{link}']") }
  end
end

Then /^I should have the following images:$/ do |table|
  table.rows.each do |links|
    links.each { |link| page.should have_xpath("//img[@src='/assets/#{link}']") }
  end
end

Then /^I should not have the following images:$/ do |table|
  table.rows.each do |links|
    links.each { |link| page.should_not have_xpath("//img[@src='/assets/#{link}']") }
  end
end

Then /^the "([^"]*)" selection should be on "([^"]*)"$/ do |field, value|
  field_labeled(field).first(:xpath, ".//option[text() = '#{value}']").should be_present
end

When /^I fill in "([^"]*)" with$/ do |field, markdown|
  fill_in(field, :with => markdown)
end

Then /^I should see "([^"]*)" with selector "([^"]*)"$/ do |text, selector|
  find(:xpath, "//#{selector}[contains(text(),'#{text}')]").should_not(be_nil, "Could not find the text '#{text}' within the selector '#{selector}'")
end

Then /^I wait for (\d+) sec$/ do |seconds|
  sleep seconds.to_i
end