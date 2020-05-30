require 'rails_helper'

describe Item, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :price }
    it { should validate_presence_of :image }
    it { should validate_presence_of :inventory }
    it { should validate_inclusion_of(:active?).in_array([true,false]) }
  end

  describe "relationships" do
    it {should belong_to :merchant}
    it {should have_many :reviews}
    it {should have_many :item_orders}
    it {should have_many(:orders).through(:item_orders)}
  end

  describe "instance methods" do
    before(:each) do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @chain = @bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)

      @review_1 = @chain.reviews.create(title: "Great place!", content: "They have great bike stuff and I'd recommend them to anyone.", rating: 5)
      @review_2 = @chain.reviews.create(title: "Cool shop!", content: "They have cool bike stuff and I'd recommend them to anyone.", rating: 4)
      @review_3 = @chain.reviews.create(title: "Meh place", content: "They have meh bike stuff and I probably won't come back", rating: 1)
      @review_4 = @chain.reviews.create(title: "Not too impressed", content: "v basic bike shop", rating: 2)
      @review_5 = @chain.reviews.create(title: "Okay place :/", content: "Brian's cool and all but just an okay selection of items", rating: 3)
    end

    it "calculate average review" do
      expect(@chain.average_review).to eq(3.0)
    end

    it "sorts reviews" do
      top_three = @chain.sorted_reviews(3,:desc)
      bottom_three = @chain.sorted_reviews(3,:asc)

      expect(top_three).to eq([@review_1,@review_2,@review_5])
      expect(bottom_three).to eq([@review_3,@review_4,@review_5])
    end

    it 'no orders' do
      expect(@chain.no_orders?).to eq(true)
      order = Order.create(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      order.item_orders.create(item: @chain, price: @chain.price, quantity: 2)
      expect(@chain.no_orders?).to eq(false)
    end
  end

  describe 'class methods' do
    it '.top_five_items' do
      meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 50, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 50)
      dragon = meg.items.create(name: "Dragon", description: "Guards your treasure as if it were its own.", price: 60, image: "https://images-na.ssl-images-amazon.com/images/I/51B9mwNncrL._AC_.jpg", inventory: 60)
      werewolf = meg.items.create(name: "Werewolf", description: "Knows when a full moon is on the rise.", price: 60, image: "https://ih1.redbubble.net/image.765064972.3394/throwpillow,small,750x600-bg,f8f8f8.jpg", inventory: 60)
      griffin = meg.items.create(name: "Griffin", description: "Will take you places.", price: 60, image: "https://m.media-amazon.com/images/I/91e1B5e8jIL._SR500,500_.jpg", inventory: 60)
      mermaid = meg.items.create(name: "Mermaid", description: "Be a mermaid from the comfort of your own home.", price: 60, image: "https://secure.img1-fg.wfcdn.com/im/59218715/resize-h800-w800%5Ecompr-r85/9053/90537369/Rosas+Kids+Mermaid+Tail+Blanket.jpg", inventory: 60)

      pull_toy = brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 30)
      dog_bone = brian.items.create(name: "Dog Bone", description: "They'll love it!", price: 20, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 20)
      frankenstein = brian.items.create(name: "Frankenstein", description: "Great read!", price: 20, image: "https://i.ebayimg.com/images/g/4A8AAOSwj9RenuF5/s-l300.jpg", active?:false, inventory: 20)
      cthulhu = brian.items.create(name: "Cthulhu", description: "Great gift!", price: 20, image: "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQP11jyikd5WuCr4Ag4RK5uCn0NMoIee3IhkW3ZQV9w0-7MKSIA&usqp=CAU", active?:false, inventory: 20)
      fairy = brian.items.create(name: "Fairy", description: "Sprinkle a little and spread your wings", price: 20, image: "https://i.etsystatic.com/6759919/r/il/806b42/1188540485/il_570xN.1188540485_fbhk.jpg", active?:false, inventory: 20)

      order_1 = Order.create(name: "Fiona", address: "123 Top Of The Tower", city: "Duloc City", state: "Duloc State", zip: 10001)

      ItemOrder.create(order_id: order_1.id, item_id: tire.id, price: 50, quantity: 10)
      ItemOrder.create(order_id: order_1.id, item_id: werewolf.id, price: 50, quantity: 9)
      ItemOrder.create(order_id: order_1.id, item_id: mermaid.id, price: 50, quantity: 8)
      ItemOrder.create(order_id: order_1.id, item_id: cthulhu.id, price: 50, quantity: 7)
      ItemOrder.create(order_id: order_1.id, item_id: fairy.id, price: 50, quantity: 6)

      ItemOrder.create(order_id: order_1.id, item_id: dragon.id, price: 50, quantity: 1)
      ItemOrder.create(order_id: order_1.id, item_id: griffin.id, price: 50, quantity: 1)
      ItemOrder.create(order_id: order_1.id, item_id: dog_bone.id, price: 50, quantity: 1)
      ItemOrder.create(order_id: order_1.id, item_id: frankenstein.id, price: 50, quantity: 1)
      ItemOrder.create(order_id: order_1.id, item_id: pull_toy.id, price: 50, quantity: 1)

      expect(Item.top_five_items).to eq([tire, werewolf, mermaid, cthulhu, fairy])
    end
  end
end
