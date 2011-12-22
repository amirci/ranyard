Fabricator(:session) do
  title    { Faker::Name.name }
  abstract { Faker::Lorem.paragraphs(4).join("\r\n\r\n") }
  planning_to_attend { rand(30) }
  tag_list! do 
    tags = %w(Ruby Alm Ms Tdd Bdd Design Mobile)
    (1..2).map { tags.sample }.join(',')
  end
end

