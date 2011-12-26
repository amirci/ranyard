Fabricator(:conference) do
  name      { Faker::Name.name      }
  start     { Date.today >> 1       }
  finish    { |conf| conf.start + 2 }
  active    { true }
  city      { Faker::Address.city }
  venue     { Faker::Name.name }
  subdomain { Faker::Internet.domain_word }
end

Fabricator(:conf_loaded, :from => :conference) do
  speakers!(count: 5) { |conf, i| Fabricate(:speaker, conference: conf) }
  sessions!(count: 5) do |conf, i| 
    Fabricate(:session, conference: conf, speakers: conf.speakers[i-1]) 
  end
  rooms!(count:4) { |conf, i| Fabricate(:room, name: "Room #{i}") }
  sponsors!(count: 5) { |conf, i| Fabricate(:sponsor, name: "Sponsor #{i}") }
end

Fabricator(:example_conference, :from => :conference) do
  subdomain { nil }
  speakers!(count: 15)  { |conf, i| Fabricate(:speaker, conference: conf, picture: 'speaker.jpg') }
  sessions!(count: 24) { |conf, i| Fabricate(:session, conference: conf, title: "The truth ##{i} about life", speakers: [conf.speakers.sample]) }
  rooms! { |conf| %w(Olympus Hogwarts Asgard).map { |w| Fabricate(:room, name: w, conference: conf) } }
  sponsors!(count: 5)  { |conf, i| Fabricate(:sponsor, name: "Sponsor #{i}", conference: conf) }
end