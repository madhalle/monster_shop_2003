require "rails_helper"

describe "As a Merchant Employee" do
  describe "when I visit an order show page from my dashboard" do

    before (:each) do
      @merchants = create_list(:merchant, 2)
      @user = User.create(name: "Fiona",
                         address: "123 Top Of The Tower",
                         city: "Duloc City",
                         state: "Duloc State",
                         zip: 10001,
                         email: "p.fiona12@castle.co",
                         password: "boom",
                         role: 1,
                          merchant_id: @merchants[0].id  )
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)


       visit '/login'

       fill_in :email, with:"p.fiona12@castle.co"
       fill_in :password, with:"boom"

       click_button "Log In"

       @orders = create_list(:order, 3, user_id: @user.id)
       @items_merch1 = create_list(:item, 3, merchant_id: @merchants[0].id)
       @items_merch2 = create_list(:item, 3, merchant_id: @merchants[1].id)

       ItemOrder.create!(order_id: @orders[0].id, item_id: @items_merch1[0].id, price: 2, quantity: 1)
       ItemOrder.create!(order_id: @orders[0].id, item_id: @items_merch1[1].id, price: 2, quantity: 3)
       ItemOrder.create!(order_id: @orders[0].id, item_id: @items_merch1[2].id, price: 2, quantity: 7)
       ItemOrder.create!(order_id: @orders[0].id, item_id: @items_merch2[0].id, price: 2, quantity: 2)
       ItemOrder.create!(order_id: @orders[0].id, item_id: @items_merch2[2].id, price: 2, quantity: 2)

       ItemOrder.create!(order_id: @orders[1].id, item_id: @items_merch1[0].id, price: 2, quantity: 1)
       ItemOrder.create!(order_id: @orders[1].id, item_id: @items_merch1[1].id, price: 2, quantity: 1)

       ItemOrder.create!(order_id: @orders[2].id, item_id: @items_merch1[0].id, price: 2, quantity: 2)

    end

    it "I can see the order show page" do

      # Change this to click_button from the merchant dashboard
      # binding.pry
      visit "/merchant/orders/#{@orders[0].id}"

      expect(page).to have_content(@orders[0].name)
      expect(page).to have_content(@orders[0].address)
      expect(page).to have_content(@orders[0].city)
      expect(page).to have_content(@orders[0].state)
      expect(page).to have_content(@orders[0].zip)

      expect(page).to_not have_content(@items_merch2[0].name)
      expect(page).to_not have_content(@items_merch2[2].name)

      within("#item-#{@items_merch1[0].id}") do
        expect(page).to have_link(@items_merch1[0].name)
        find("img[src*='#{@items_merch1[0].image}']")
        expect(page).to have_content(@items_merch1[0].price)
        expect(page).to have_content(1)
      end

      within("#item-#{@items_merch1[1].id}") do
        expect(page).to have_link(@items_merch1[1].name)
        find("img[src*='#{@items_merch1[1].image}']")
        expect(page).to have_content(@items_merch1[1].price)
        expect(page).to have_content(3)
      end

      within("#item-#{@items_merch1[2].id}") do
        expect(page).to have_link(@items_merch1[2].name)
        find("img[src*='#{@items_merch1[2].image}']")
        expect(page).to have_content(@items_merch1[2].price)
        expect(page).to have_content(2)
      end
    end

    it "I can fulfill parts of the order" do
      visit "/merchant/orders/#{@orders[0].id}"

      within("#item-#{@items_merch1[0].id}") do
        expect(page).to have_content("Status: unfulfilled")
        click_on "fulfill"
      end

      expect(page).to have_content("You have fulfilled #{@items_merch1[0].name}")

      within("#item-#{@items_merch1[0].id}") do
        expect(page).to have_content("Status: fulfilled")
        expect(page).to_not have_link("fulfill")
      end

      expect(@items_merch1[0].reload.inventory).to eq(2)

    end

    it "I can not fulfill items if the quantity requested is larger than the item's inventory" do
      visit "/merchant/orders/#{@orders[0].id}"
      save_and_open_page

      within("#item-#{@items_merch1[0].id}") do
        expect(page).to have_content("Status: unfulfilled")
        click_on "fulfill"
      end

      within("#item-#{@items_merch1[2].id}") do
        expect(page).to have_content("Status: unfulfilled")
        expect(page).to_not have_link("fulfill")
        expect(page).to have_content("This item cannot currently be fulfilled")
      end
    end
  end
end
