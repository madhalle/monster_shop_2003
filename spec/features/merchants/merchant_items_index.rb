require 'rails_helper'

RSpec.describe "Merchant Items Index Page" do
  describe "When a merchant visits their items index page" do
    before(:each) do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @user_meg = User.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203, email: 'merchant_meg@merchants.com', role: 1, password: 'password')
      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @pull_toy = @meg.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)

      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
      @dog_bone = @brian.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user_meg)
    end

    it "it displays item name, description, price, image, status and inventory" do
      visit '/items'

      expect(page).to have_link(@tire.name)
      expect(page).to have_link(@tire.merchant.name)
      expect(page).to have_css("img[src*='#{@tire.image}']")
      expect(page).to have_link(@pull_toy.name)
      expect(page).to have_link(@pull_toy.merchant.name)
      expect(page).to have_css("img[src*='#{@pull_toy.image}']")
      expect(page).to_not have_link(@dog_bone.name)
    end
  end

end

it "I can see a list of all of the items "do

  visit '/items'

  within "#item-#{@tire.id}" do
    expect(page).to have_link(@tire.name)
    expect(page).to have_content(@tire.description)
    expect(page).to have_content("Price: $#{@tire.price}")
    expect(page).to have_content("Active")
    expect(page).to have_content("Inventory: #{@tire.inventory}")
    expect(page).to have_link(@meg.name)
    expect(page).to have_css("img[src*='#{@tire.image}']")
  end

  within "#item-#{@pull_toy.id}" do
    expect(page).to have_link(@pull_toy.name)
    expect(page).to have_content(@pull_toy.description)
    expect(page).to have_content("Price: $#{@pull_toy.price}")
    expect(page).to have_content("Active")
    expect(page).to have_content("Inventory: #{@pull_toy.inventory}")
    expect(page).to have_link(@brian.name)
    expect(page).to have_css("img[src*='#{@pull_toy.image}']")
  end

    expect(page).to_not have_css("#item-#{@dog_bone.id}")
end
