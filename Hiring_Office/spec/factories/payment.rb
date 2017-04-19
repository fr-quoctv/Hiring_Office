FactoryGirl.define do
  factory :payment do
    name "paypal"
    price {Faker::Number.decimal(2)}
    notification_params "success"
    status "string"
    transaction_id "1"
    order
  end
end
