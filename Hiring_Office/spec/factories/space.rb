FactoryGirl.define do
  factory :space do
    name Faker::Name.name
    space_type :desk
    area 10
    capicity 4
    quantity 2
    description "description"
    venue
  end
end
