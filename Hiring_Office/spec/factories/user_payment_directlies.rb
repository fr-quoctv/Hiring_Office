FactoryGirl.define do
  factory :user_payment_directly do
    name "MyString"
    email {Faker::Internet.email}
    address "MyString"
    phone 1
    order nil
  end
end
