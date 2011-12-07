Then /^I switch the subdomain to "(\w+)"$/ do |s|
  Capybara.default_host = "http://#{s}.example.com"
  visit root_path(subdomain: s)
end