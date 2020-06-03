require "rails_helper"

RSpec.describe "Admin Merchants Index Page", type: :feature do
  describe "as an Admin when I visit the merchants index page" do
    before(:each) do
      @user = User.create(name: "Fiona",
                         address: "123 Top Of The Tower",
                         city: "Duloc City",
                         state: "Duloc State",
                         zip: 10001,
                         email: "p.fiona12@castle.co",
                         password: "boom",
                         role: 2)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @mike = Merchant.create(name: "Mike's Shop", address: '100 Lane Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 50, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 50)
      @dragon = @mike.items.create(name: "Dragon", description: "Guards your treasure as if it were its own.", price: 60, image: "https://images-na.ssl-images-amazon.com/images/I/51B9mwNncrL._AC_.jpg", inventory: 60)
      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 30)
      @dog_bone = @brian.items.create(name: "Dog Bone", description: "They'll love it!", price: 20, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", inventory: 20)

      visit '/login'

      fill_in :email, with:"p.fiona12@castle.co"
      fill_in :password, with:"boom"

      click_button "Log In"
    end

    it "can disable merchants who are not yet disabled" do
      visit "/admin/merchants"

      within "#merchant#{@meg.id}" do
        expect(page).to have_button("Disable")
      end

      within "#merchant#{@mike.id}" do
        expect(page).to have_button("Disable")
      end

      within "#merchant#{@brian.id}" do
        expect(page).to have_button("Disable")
        click_button "Disable"
      end

      expect(current_path).to eq("/admin/merchants")
      expect(page).to have_content("#{@brian.name}'s account has been disabled.")
    end

    it "can disable all merchant items if merchant is disabled" do
      visit "/admin/merchants"

      expect(@tire.active?).to eq(true)
      expect(@dragon.active?).to eq(true)
      expect(@pull_toy.active?).to eq(true)
      expect(@dog_bone.active?).to eq(true)

      within "#merchant#{@brian.id}" do
        click_button "Disable"
      end

      @tire.reload
      @dragon.reload
      @pull_toy.reload
      @dog_bone.reload

      expect(@tire.active?).to eq(true)
      expect(@dragon.active?).to eq(true)
      expect(@pull_toy.active?).to eq(false)
      expect(@dog_bone.active?).to eq(false)
    end

    it "can enable merchants who are disabled" do
      @meg.update(:active? => false)
      visit "/admin/merchants"

      within "#merchant#{@meg.id}" do
        expect(page).to have_button("Enable")
        click_button "Enable"
      end

      expect(current_path).to eq("/admin/merchants")

      @meg.update(:active? => true)
      @meg.reload
      expect(@meg.active?).to eq(true)

      expect(page).to have_content("#{@meg.name}'s account has been enabled.")
      expect(page).to_not have_button("Enable")
      expect(page).to have_button("Disable")

      # User Story 40, Admin enables a merchant account
      #
      # As an admin
      # When I visit the merchant index page
      # I see an "enable" button next to any merchants whose accounts are disabled
      # When I click on the "enable" button
      # I am returned to the admin's merchant index page where I see that the merchant's account is now enabled
      # And I see a flash message that the merchant's account is now enabled
    end

    it "can enable items for an enabled merchant" do
      visit "/admin/merchants"

      within "#merchant#{@brian.id}" do
        click_button "Disable"
      end

      @pull_toy.reload
      @dog_bone.reload

      expect(@pull_toy.active?).to eq(false)
      expect(@dog_bone.active?).to eq(false)

      within "#merchant#{@brian.id}" do
        click_button "Enable"
      end

      @pull_toy.reload
      @dog_bone.reload

      expect(@pull_toy.active?).to eq(true)
      expect(@dog_bone.active?).to eq(true)

      # User Story 41, Enabled Merchant Item's are active
      #
      # As an admin
      # When I visit the merchant index page
      # And I click on the "enable" button for a disabled merchant
      # Then all of that merchant's items should be activated
    end
  end
end
