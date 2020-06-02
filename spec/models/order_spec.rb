require 'rails_helper'

describe Order, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
  end

  describe "relationships" do
    it {should have_many :item_orders}
    it {should have_many(:items).through(:item_orders)}
  end

  describe 'instance methods' do
    before :each do

      @user = User.create(name: "Fiona",
                         address: "123 Top Of The Tower",
                         city: "Duloc City",
                         state: "Duloc State",
                         zip: 10001,
                         email: "p.fiona12@castle.co",
                         password: "boom",
                         role: 0)

      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)

      @order_1 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user_id: @user.id)
      @order_2 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user_id: @user.id)

      @order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
      @order_1.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 3)
      @order_2.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 6)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    end
    it 'grandtotal' do
      expect(@order_1.grandtotal).to eq(230)
    end

    it '#unique_item_count' do
      expect(@order_1.unique_item_count).to eq(2)
      expect(@order_2.unique_item_count).to eq(1)
    end

    it '#total_item_count' do
      expect(@order_1.total_item_count).to eq(5)
      expect(@order_2.total_item_count).to eq(6)
    end

    it '#all_items_fulfilled?' do
      expect(@order_1.all_items_fulfilled?).to eq(false)

      @order_1.item_orders.each do |item_order|
        item_order.fulfill
      end

      expect(@order_1.all_items_fulfilled?).to eq(true)
    end

    it '#package' do
      expect(@order_1.status).to eq("pending")

      @order_1.package

      expect(@order_1.status).to eq("pending")

      @order_1.item_orders.each do |item_order|
        item_order.fulfill
      end
      @order_1.package

      expect(@order_1.status).to eq("packaged")
    end

    describe "Class Methods" do
      it '#sort_by_status' do
        ItemOrder.destroy_all
        Order.destroy_all

        pending_orders = create_list(:order, 3, user_id: @user.id, status: "pending")
        packaged_orders = create_list(:order, 3, user_id: @user.id, status: "packaged")
        shipped_orders = create_list(:order, 3, user_id: @user.id, status: "shipped")
        cancelled_orders = create_list(:order, 3, user_id: @user.id, status: "cancelled")

        sorted_orders = Order.sort_by_status

        expect(sorted_orders["pending"]).to eq(pending_orders)
        expect(sorted_orders["packaged"]).to eq(packaged_orders)
        expect(sorted_orders["shipped"]).to eq(shipped_orders)
        expect(sorted_orders["cancelled"]).to eq(cancelled_orders)
      end
    end
  end
end
