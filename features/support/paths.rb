module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    
    case page_name

      when /^the home\s?page$/
        '/'

      when /^the sign in page$/
        "/log_in"
      
      when /^API \"(.*)\"/
        $1

      # Add more mappings here.
      # Here is an example that pulls values out of the Regexp:
      #
      #   when /^(.*)'s profile page$/i
      #     user_profile_path(User.find_by_login($1))

      else
        begin
          page_name =~ /^the (.*) page$/
          path_symbol = $1.split(/\s+/).push('path').join('_').to_sym
          self.send(path_symbol)
        rescue NoMethodError, ArgumentError => e
          raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
            "Now, go and add a mapping in #{__FILE__}"
        end
      end
  end
end

World(NavigationHelpers)
