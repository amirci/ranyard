Fabricator(:event) do
  start  { DateTime.now + 1.day }
  finish { |e| e.start + 75.minutes }
  custom { Faker::Lorem.sentence }
  main   { rand(20) % 4 == 3 }
  room!  
end
