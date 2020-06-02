FactoryBot.define do
  factory :user do
    name { "Princess Fiona" }
    address { "123 Top Of The Tower" }
    city { "Duloc City" }
    state { "Duloc State" }
    zip { 10001 }
    sequence(:email) {|n| "P.fiona#{n * rand(1000000)}"}
    password { "boom" }
    active? { false }
  end
end
