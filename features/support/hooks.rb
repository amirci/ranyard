After do |s| 
  # restore default host
  Capybara.default_host = "http://www.example.com"
  
  # Tell Cucumber to quit after this scenario is done - if it failed.
  Cucumber.wants_to_quit = true if s.failed?
end