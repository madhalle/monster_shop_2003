require "rails_helper"

describe "As an Admin" do
  describe "when I visit my dashboard" do

    before (:each) do
      @user = User.create(name: "Fiona",
                         address: "123 Top Of The Tower",
                         city: "Duloc City",
                         state: "Duloc State",
                         zip: 10001,
                         email: "p.fiona12@castle.co",
                         password: "boom",
                         role: 2)
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

    it "I see all orders in the system" do
      visit "/admin"

      within("#order-#{@orders[0].id}") do
        expect(page).to have_link("#{@orders[0].id}")
        expect(page).to have_content("Ordered On: #{@orders[0].created_at}")
        expect(page).to have_content("Order Status: #{@orders[0].status}")
      end
      within("#order-#{@orders[1].id}") do
        expect(page).to have_link("#{@orders[1].id}")
        expect(page).to have_content("Ordered On: #{@orders[1].created_at}")
        expect(page).to have_content("Order Status: #{@orders[1].status}")

      end
      within("#order-#{@orders[2].id}") do
        expect(page).to have_link("#{@orders[2].id}")
        expect(page).to have_content("Ordered On: #{@orders[2].created_at}")
        expect(page).to have_content("Order Status: #{@orders[2].status}")
      end
    end

    it "I see are orders are sorted by their status" do
      packaged_orders = create_list(:order, 3, user_id: @user.id, status: "packaged")
      shipped_orders = create_list(:order, 3, user_id: @user.id, status: "shipped")
      cancelled_orders = create_list(:order, 3, user_id: @user.id, status: "cancelled")

      visit "/admin"

      within("#packaged-orders") do
        expect(page).to have_content(packaged_orders[0].id)
        expect(page).to have_content(packaged_orders[1].id)
        expect(page).to have_content(packaged_orders[2].id)

        expect(page).to_not have_content(@orders[0].id)
        expect(page).to_not have_content(shipped_orders[0].id)
        expect(page).to_not have_content(cancelled_orders[0].id)
      end

      within("#pending-orders") do
        expect(page).to have_content(@orders[0].id)
        expect(page).to have_content(@orders[1].id)
        expect(page).to have_content(@orders[2].id)

        expect(page).to_not have_content(packaged_orders[0].id)
        expect(page).to_not have_content(shipped_orders[0].id)
        expect(page).to_not have_content(cancelled_orders[0].id)
      end

      within("#shipped-orders") do
        expect(page).to have_content(shiped_orders[0].id)
        expect(page).to have_content(shiped_orders[1].id)
        expect(page).to have_content(shiped_orders[2].id)

        expect(page).to_not have_content(packaged_orders[0].id)
        expect(page).to_not have_content(@orders[0].id)
        expect(page).to_not have_content(cancelled_orders[0].id)
      end

      within("#cancelled-orders") do
        expect(page).to have_content(cancelled_orders[0].id)
        expect(page).to have_content(cancelled_orders[1].id)
        expect(page).to have_content(cancelled_orders[2].id)

        expect(page).to_not have_content(packaged_orders[0].id)
        expect(page).to_not have_content(shipped_orders[0].id)
        expect(page).to_not have_content(@orders[0].id)
      end
    end

    it "For an order the user's name links to the admin view of the user's profile" do
      visit "/admin"

      click_on @orders[0].name

      expect(current_path).to eq("/admin/users/#{@orders[0].user_id}")
    end
  end
end
