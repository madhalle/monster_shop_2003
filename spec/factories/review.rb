FactoryBot.define do
  factory :review do
    title { "No One mentioned the smell" }
    content { "Don't feed donkey table scraps, you will need to evacuate" }
    rating { 3 }
    item
  end
end
