require 'rails_helper'

RSpec.describe "Login" do
  describe "when a visitor visits login path" do

    before(:each) do
      @registered_user = User.create!(name: "Shrek",
                         address: "123 Top Of The Tower",
                         city: "Duloc City",
                         state: "Duloc State",
                         zip: 10001,
                         email: "bigshrek12@castle.co",
                         password: "boom",
                         role: 0)
      @merchant = User.create!(name: "Fiona",
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

      expect(current_path).to eq("/profile/#{@registered_user.id}")
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

      expect(current_path).to eq("/profile/#{@registered_user.id}")
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
  end
end
