FactoryGirl.define do
  factory :notification do
    notifiable_type {Faker::Lorem.word}
    notifiable_id 1
    receiver_id 1
    owner_id 1
    status 0
    message {Faker::Lorem.word}
  end
end
