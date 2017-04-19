FactoryGirl.define do
  factory :user_role_venue do
    user
    venue
    type_role "owner"
  end
end
