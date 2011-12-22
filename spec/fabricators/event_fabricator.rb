Fabricator(:event) do
  start  { DateTime.now + 1.day }
  finish { |e| e.start + 75.minutes }
  custom { Faker::Lorem.sentence }
  main   { rand(20) % 4 == 3 }
  room!  
end

Fabricator(:lunch, :from => :event) do
  finish { |e| e.start + 1.hour}  
  custom { 'Lunch' }
  main   { true    }
  room   { nil     }
end

Fabricator(:breakfast, :from => :lunch) do
  custom { 'Breakfast' }
end


Fabricator(:session_event, :from => :event) do
  finish     { |e| e.start + 1.hour} 
  custom     { nil   } 
  main       { false }
  room!      { Conference.first.rooms.all.sample }
end
