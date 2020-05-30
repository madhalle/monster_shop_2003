require "rails_helper"

describe "As a default user" do
  describe "when I visit my profile page" do

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
    end

    it "I can edit my profile" do

      visit "/profile"

      click_on "Edit Profile"

      expect(current_path).to eq("/profile/edit")

      fill_in :city, with: "Swamp"
      fill_in :password, with: "boom"
      fill_in :password_confirmation, with: "boom"
      click_on "Update Profile"
      save_and_open_page
      expect(current_path).to eq("/profile")
      expect(page).to have_content("Your profile has been updated")
      expect(page).to have_content("City: Swamp")
    end
  end
end
