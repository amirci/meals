
FactoryGirl.define do
  factory :meal do
    meal      { Faker::Name.first_name }
    logged_at { 3.days.ago }
    calories  1500
  end
end