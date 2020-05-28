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
    xit "as a merchant, they are directed to their merchant dashboard page" do

    end
    xit "as an admin, they are directed to their admin dashboard page" do

    end

  end
end
# [ ] done
#
# User Story 13, User can Login
#
# As a visitor
# When I visit the login path
# I see a field to enter my email address and password
# When I submit valid information
# If I am a regular user, I am redirected to my profile page
# If I am a merchant user, I am redirected to my merchant dashboard page
# If I am an admin user, I am redirected to my admin dashboard page
# And I see a flash message that I am logged in
# ```
