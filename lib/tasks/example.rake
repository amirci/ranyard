namespace :example do

  desc 'Setup example conference'
  task :setup => ['db:drop', 'db:setup', :environment] do
    conf = Fabricate(:conference, subdomain: nil)
    speakers = (1..5).map { |i| Fabricate(:speaker, conference: conf, picture: 'speaker.jpg') }
    sessions = (1..5).map do|i| 
      s = Fabricate(:session, title: "The truth ##{i} about life", conference: conf) 
      s.speakers = [speakers[i - 1]]
      s.save
      s
    end
  end
  
end