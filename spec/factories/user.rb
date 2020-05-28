FactoryBot.define do
  factory :user do
    name { "Princess Fiona" }
    address { "123 Top Of The Tower" }
    city { "Duloc City" }
    state { "Duloc State" }
    zip { 10001 }
    email { "p.fiona12@castle.co" }
    sequence(:password_digest) { |n| "user#{n}" }
    role { "Don't feed donkey table scraps, you will need to evacuate" }
    active { False }

  end
end
