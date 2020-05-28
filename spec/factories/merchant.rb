FactoryBot.define do
  factory :merchant do
    name { "Donkey Seller" }
    address { "12 Monster Lane" }
    city { "Duloc City" }
    state { "Duloc State" }
    zip { 10001 }
  end
end
