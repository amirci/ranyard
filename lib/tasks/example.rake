namespace :example do

  desc 'Setup example conference'
  task :setup => ['db:drop', 'db:setup', :environment] do
    c = Fabricate(:example_conference)

    i = -1
    c.days.map do |d|
      Fabricate(:breakfast, start: d + 8.hours, conference: c) 
      (9..11).map { |hour| Fabricate(:session_event, start: d + hour.hours, conference: c, session: c.sessions[i += 1]) } 
      Fabricate(:lunch, start: d + 12.hours, conference: c) 
      (13..16).map { |hour| Fabricate(:session_event, start: d + hour.hours, conference: c, session: c.sessions[i += 1]) }
    end

  end
  
end