require 'rails_helper'

RSpec.describe "when logged in as a merchant employee" do
  before :each do
    @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 23137)
    @merchant = @bike_shop.users.create!(name: "Fiona",
                       address: "123 Top Of The Tower",
                       city: "Duloc City",
                       state: "Duloc State",
                       zip: 10001,
                       email: 'gingerbread.man@sweets.com',
                       password: "boom",
                       role: 1)

    @tire = @bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @paper = @bike_shop.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
    @pencil = @bike_shop.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)


  end
  it "I will see name & address of merchant I work for on my dashboard" do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
     visit "/merchant"
     expect(page).to have_content(@bike_shop.name)
     expect(page).to have_content(@bike_shop.address)
     expect(page).to have_content(@bike_shop.city)
     expect(page).to have_content(@bike_shop.state)
     expect(page).to have_content(@bike_shop.zip)
  end

  xit "I will see a link to view my items" do
     visit "/merchant"
     click_on "View Your Items"
     expect(current_path).to eq("/merchant/items")
  end

  it "I will see name & address of merchant I work for on my dashboard" do
    @user = User.create!(name: "Fiona",
                       address: "123 Top Of The Tower",
                       city: "Duloc City",
                       state: "Duloc State",
                       zip: 10001,
                       email: "p.fiona12@castle.co",
                       password: "boom",
                       role: 0)

    @order =@user.orders.create!(name: "Fiona", address: 'over there', city:'duloc', state:'duloc', zip: 10001)
    ItemOrder.create!(item: @tire, order: @order, price: 100, quantity: 1)
    ItemOrder.create!(item: @paper, order: @order, price: 100, quantity: 1)
    ItemOrder.create!(item: @pencil, order: @order, price: 100, quantity: 1)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)

    visit "/merchant"


    expect(page).to have_content(@order.id)
    expect(page).to have_content(@order.created_at.strftime("%m/%d/%Y"))
  end
end
