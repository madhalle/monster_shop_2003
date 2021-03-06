require 'rails_helper'

RSpec.describe "Login" do
  describe "when a visitor visits login path" do

    before(:each) do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 23137)

      @registered_user = User.create!(name: "Shrek",
                         address: "123 Top Of The Tower",
                         city: "Duloc City",
                         state: "Duloc State",
                         zip: 10001,
                         email: "bigshrek12@castle.co",
                         password: "boom",
                         role: 0)
      @merchant = @bike_shop.users.create!(name: "Fiona",
                         address: "123 Top Of The Tower",
                         city: "Duloc City",
                         state: "Duloc State",
                         zip: 10001,
                         email: "p.fiona12@castle.co",
                         password: "boom",
                         role: 1)
      @admin = User.create!(name: "Donkey",
                         address: "123 Top Of The Tower",
                         city: "Duloc City",
                         state: "Duloc State",
                         zip: 10001,
                         email: "donkey@castle.co",
                         password: "boom",
                         role: 2)
    end

    it "as a regular user, they are directed to their profile page" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@registered_user)
      visit '/login'

      fill_in :email, with:"bigshrek12@castle.co"
      fill_in :password, with:"boom"

      click_button "Log In"

      expect(current_path).to eq("/profile")
    end

    it "as a merchant, they are directed to their merchant dashboard page" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
      visit '/login'

      fill_in :email, with:"p.fiona12@castle.co"
      fill_in :password, with:"boom"

      click_button "Log In"

      expect(current_path).to eq("/merchant")
    end

    it "as an admin, they are directed to their admin dashboard page" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
      visit '/login'

      fill_in :email, with:"donkey@castle.co"
      fill_in :password, with:"boom"

      click_button "Log In"

      expect(current_path).to eq("/admin")
      expect(page).to have_content("Welcome, #{@admin.name}!")
    end

    it "will display an error flash if credentials are bad" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
      visit '/login'

      fill_in :email, with:"donkey@castle.co"
      fill_in :password, with:"bomm"

      click_button "Log In"

      expect(current_path).to eq("/login")
      expect(page).to have_content("Sorry, your credentials are bad.")
    end


    it "As a registered user, I see a message indicating I am already logged in" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@registered_user)

      visit "/login"

      fill_in :email, with:"bigshrek12@castle.co"
      fill_in :password, with:"boom"

      click_button "Log In"

      visit "/login"

      expect(current_path).to eq("/profile")
      expect(page).to have_content("I am already logged in")
    end

    it "As a merchant, I see a message indicating I am already logged in" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)

      visit "/login"

      fill_in :email, with:"p.fiona12@castle.co"
      fill_in :password, with:"boom"

      click_button "Log In"

      visit "/login"

      expect(current_path).to eq("/merchant")
      expect(page).to have_content("I am already logged in")
    end

    it "As an admin, I see a message indicating I am alreay logged in" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)

      visit "/login"

      fill_in :email, with:"donkey@castle.co"
      fill_in :password, with:"boom"

      click_button "Log In"

      visit "/login"

      expect(current_path).to eq("/admin")
      expect(page).to have_content("I am already logged in")
    end

    # it "will display an error flash if user is already logged in" do
    #   allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
    #   visit '/login'
    #
    #   fill_in :email, with:"donkey@castle.co"
    #   fill_in :password, with:"boom"
    #
    #   click_button "Log In"
    #
    #   expect(page).to have_content("You are already logged in.")
    #   expect(current_path).to eq("/login")
    # end

  end
end
# [x] done
#
# User Story 15, Users who are logged in already are redirected
#
# As a registered user, merchant, or admin
# When I visit the login path
# If I am a regular user, I am redirected to my profile page
# If I am a merchant user, I am redirected to my merchant dashboard page
# If I am an admin user, I am redirected to my admin dashboard page
# And I see a flash message that tells me I am already logged in
# ```
