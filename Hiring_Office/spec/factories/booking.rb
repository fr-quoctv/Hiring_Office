FactoryGirl.define do
  factory :booking do
    duration 1
    booking_from {Faker::Time.between(DateTime.now - 1, DateTime.now)}
    quantity 10
    state 2
    user
    space
    booking_type nil
  end
end
