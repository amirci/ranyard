Given /^I'm logged in as an admin$/ do
  Given %{I am a user named "admin" with an email "admin@gmail.com" and password "admin"}
  Given %{I sign in as "admin@gmail.com/admin"}
end

Given /^no user exists with an email of "(.*)"$/ do |email|
  User.find(:first, :conditions => { :email => email }).should be_nil
end

Given /^I am a user named "([^"]*)" with an email "([^"]*)" and password "([^"]*)"$/ do |name, email, password|
  User.new(:email => email,
           :password => password).save!
end

Then /^I should be already signed in$/ do
  And %{I should see "Log Out"}
end

Then /^I sign out$/ do
  visit('/log_out')
end

Given /^I am logout$/ do
  Given %{I sign out}
end

Given /^I am not logged in$/ do
  Given %{I sign out}
end

When /^I sign in as "(.*)\/(.*)"$/ do |email, password|
  Given %{I am not logged in}
  When  %{I go to the sign in page}
  And   %{I fill in "Email" with "#{email}"}
  And   %{I fill in "Password" with "#{password}"}
  And   %{I press "Log in"}
end

Then /^I should be signed in$/ do
  Then %{I should see "Log Out"}
end

When /^I return next time$/ do
  And %{I go to the home page}
end

Then /^I should be signed out$/ do
  And %{I should not see "Log Out"}
end
