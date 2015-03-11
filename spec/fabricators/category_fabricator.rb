Fabricator(:category) do
  title { Faker::Lorem.name }
  description { Faker::Lorem.paragraph }
end