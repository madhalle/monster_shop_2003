require 'rails_helper'

RSpec.describe "when logged in as a merchant employee" do
  before :each do
    @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 23137)
    @user = @bike_shop.users.create!(name: "Fiona",
                       address: "123 Top Of The Tower",
                       city: "Duloc City",
                       state: "Duloc State",
                       zip: 10001,
                       email: 'gingerbread.man@sweets.com',
                       password: "boom",
                       role: 1)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
  end
  it "I will see name & address of merchant I work for on my dashboard" do
     visit "/merchant"
     expect(page).to have_content(@bike_shop.name)
     expect(page).to have_content(@bike_shop.address)
     expect(page).to have_content(@bike_shop.city)
     expect(page).to have_content(@bike_shop.state)
     expect(page).to have_content(@bike_shop.zip)
  end

  it "I will see a link to view my items" do
     visit "/merchant"
     click_on "View Your Items"
     expect(current_path).to eq("/merchant/items")
  end
end
