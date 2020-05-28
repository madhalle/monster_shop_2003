require "rails_helper"

describe "As a default user" do
  describe "when I visit my profile page" do
    it "I can edit my profile" do
      user = User.create(name: "Fiona",
                         address: "123 Top Of The Tower",
                         city: "Duloc City",
                         state: "Duloc State",
                         zip: 10001,
                         email: "p.fiona12@castle.co",
                         password: "boom",
                         role: 0)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit "/user/profile"

      click_on "Edit Profile"

      expect(current_path).to eq("/user/profile/edit")

      fill_in :city, with: "Swamp"
      click_on "Update Profile"

      expect(current_path).to eq("/user/profile")
      expect(page).to have_content("Your profile has been updated")
      expect(page).to have_content("City: Swamp")
    end
  end
end
