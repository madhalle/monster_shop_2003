require "rails_helper"

describe "An orders status will be updated when" do

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

  it "All items in the order have been 'fulfilled'" do
    expect(@orders[0].status).to eq("pending")

    @orders[0].item_orders.each do |item_order|
      expect(item_order.status).to eq("unfulfilled")
      expect(@orders[0].status).to eq("pending")
      item_order.update_attributes!(status: "fulfilled")
    end
    @orders[0].package
    expect(@orders[0].status).to eq("packaged")
  end
end
