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
    s = Fabricate(:session, conference: conf) 
    s.speakers << conf.speakers[i-1]
    s
  end
  rooms!(count:4) { |conf, i| Fabricate(:room, name: "Room #{i}") }
  sponsors!(count: 5) { |conf, i| Fabricate(:sponsor, name: "Sponsor #{i}") }
end