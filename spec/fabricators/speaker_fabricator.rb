Fabricator(:speaker) do
  bio      { Faker::Lorem.paragraphs(6).join("\r\n\r\n")  }
  blog     { Faker::Internet.domain_name }
  email    { Faker::Internet.email       }
  location { Faker::Address.city         }
  name     { Faker::Name.name            }
  twitter  { Faker::Internet.user_name   }
  website  { Faker::Internet.domain_name }
  picture  { Faker::Internet.user_name + ".jpg" }
end
