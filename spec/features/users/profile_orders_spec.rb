require "rails_helper"

describe "As a default user" do
  describe "when I visit my profile/orders page" do

    before (:each) do
      @user = User.create(name: "Fiona",
                         address: "123 Top Of The Tower",
                         city: "Duloc City",
                         state: "Duloc State",
                         zip: 10001,
                         email: "p.fiona12@castle.co",
                         password: "boom",
                         role: 0)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)


       visit '/login'

       fill_in :email, with:"p.fiona12@castle.co"
       fill_in :password, with:"boom"

       click_button "Log In"

       @orders = create_list(:order, 3, user_id: @user.id)
       @items = create_list(:item, 3)

       ItemOrder.create!(order_id: @orders[0].id, item_id: @items[0].id, price: 2, quantity: 1)
       ItemOrder.create!(order_id: @orders[0].id, item_id: @items[1].id, price: 2, quantity: 1)
       ItemOrder.create!(order_id: @orders[0].id, item_id: @items[2].id, price: 2, quantity: 1)

       ItemOrder.create!(order_id: @orders[1].id, item_id: @items[0].id, price: 2, quantity: 1)
       ItemOrder.create!(order_id: @orders[1].id, item_id: @items[1].id, price: 2, quantity: 1)

       ItemOrder.create!(order_id: @orders[2].id, item_id: @items[0].id, price: 2, quantity: 2)

    end

    it "I can see every order I've made" do
      visit "/profile/orders"
  
      within("#order-#{@orders[0].id}") do
        expect(page).to have_link("#{@orders[0].id}")
        expect(page).to have_content("Ordered On: #{@orders[0].created_at}")
        expect(page).to have_content("Updated On: #{@orders[0].updated_at}")
        expect(page).to have_content("Order Status: #{@orders[0].status}")
        expect(page).to have_content("Unique Items: 3")
        expect(page).to have_content("Total Items: 3")
      end
      within("#order-#{@orders[1].id}") do
        expect(page).to have_link("#{@orders[1].id}")
        expect(page).to have_content("Ordered On: #{@orders[1].created_at}")
        expect(page).to have_content("Updated On: #{@orders[1].updated_at}")
        expect(page).to have_content("Order Status: #{@orders[1].status}")
        expect(page).to have_content("Unique Items: 2")
        expect(page).to have_content("Total Items: 2")
      end
      within("#order-#{@orders[2].id}") do
        expect(page).to have_link("#{@orders[2].id}")
        expect(page).to have_content("Ordered On: #{@orders[2].created_at}")
        expect(page).to have_content("Updated On: #{@orders[2].updated_at}")
        expect(page).to have_content("Order Status: #{@orders[2].status}")
        expect(page).to have_content("Unique Items: 1")
        expect(page).to have_content("Total Items: 2")
      end
    end
  end
end
