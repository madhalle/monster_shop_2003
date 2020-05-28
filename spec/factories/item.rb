FactoryBot.define do
  factory :item do
    name { "Donkey" }
    description { "Talks a bit too much" }
    price { 2 }
    image { "https://vignette.wikia.nocookie.net/shrek/images/d/dc/DonkeyTransparent.png/revision/latest?cb=20171218193004" }
    active? { true }
    inventory { 1 }
    merchant
  end
end
