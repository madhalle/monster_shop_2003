FactoryBot.define do
  factory :order do
    name { "P. Fiona" }
    address { "123 Top Of The Tower" }
    city { "Duloc City" }
    state { "Duloc State" }
    zip { 10001 }
  end
end
