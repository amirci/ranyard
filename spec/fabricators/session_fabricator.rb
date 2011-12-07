Fabricator(:session) do
  title    { Faker::Name.name }
  abstract { Faker::Lorem.paragraph }
  planning_to_attend { rand(30) }
  tag_list! do 
    tags = %w(Ruby Alm Ms Tdd Bdd Design Mobile)
    (1..2).map { tags[rand(tags.length)] }.join(',')
  end
end

Fabricator(:session_loaded, :from => :session) do
end
