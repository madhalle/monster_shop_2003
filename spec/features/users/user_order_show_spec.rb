

require "rails_helper"

RSpec.describe "User's Oder Show Page", type: :feature do
  describe "as a registered user" do
    it "I am taken to an order's show page when I click on an order link" do
      user = User.create(name: "Fiona",
                         address: "123 Top Of The Tower",
                         city: "Duloc City",
                         state: "Duloc State",
                         zip: 10001,
                         email: "p.fiona12@castle.co",
                         password: "boom",
                         role: 0)
      bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

      tire = bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 60)
      chain = bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 60)

      order = Order.create(name: "Fiona", address: "123 Top Of The Tower", city: "Duloc City", state: "Duloc State", zip: 10001, user_id: user.id)
      order_2 = Order.create(name: "Fiona", address: "123 Top Of The Tower", city: "Duloc City", state: "Duloc State", zip: 10001, user_id: user.id)

      ItemOrder.create(order_id: order.id, item_id: tire.id, price: 50, quantity: 10)
      ItemOrder.create(order_id: order.id, item_id: chain.id, price: 50, quantity: 10)

      visit "/login"
      fill_in :email, with: user.email
      fill_in :password, with: user.password
      click_button "Log In"
      visit "/profile"
      click_link("My Orders")

      click_link "Order Id: #{order.id}"

      expect(current_path).to eq("/profile/orders/#{order.id}")

      expect(page).to have_content(order.id)
      expect(page).to have_content(order.created_at)
      expect(page).to have_content(order.updated_at)
      expect(page).to have_content("Total Items: 20")
      expect(page).to have_content("Grand Total: 1000.0")
      expect(page).to_not have_content(order_2.id)
    end
  end
end


# - the ID of the order
# - the date the order was made
# - the date the order was last updated
# - the current status of the order
# - each item I ordered, including name, description, thumbnail, quantity, price and subtotal
# - the total quantity of items in the whole order
# - the grand total of all items for that order
