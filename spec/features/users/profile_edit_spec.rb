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
      @user2 = User.create(name: "Fiona",
                         address: "123 Top Of The Tower",
                         city: "Duloc City",
                         state: "Duloc State",
                         zip: 10001,
                         email: "p.fiona112@castle.co",
                         password: "boom",
                         role: 0)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
       visit '/login'

       fill_in :email, with:"p.fiona12@castle.co"
       fill_in :password, with:"boom"

    end

    it "I can edit my profile" do
      click_button "Log In"

      visit "/profile"

      click_on "Edit Profile"

      expect(current_path).to eq("/profile/edit")

      fill_in :city, with: "Swamp"
      fill_in :password, with: "boom"
      fill_in :password_confirmation, with: "boom"

      click_on "Update Profile"
      expect(current_path).to eq("/profile")
      expect(page).to have_content("Your profile has been updated")
      expect(page).to have_content("City: Swamp")
    end

    it "will return error flash if email is already taken" do
      click_button "Log In"

      visit "/profile"

      click_on "Edit Profile"

      expect(current_path).to eq("/profile/edit")

      fill_in :email, with: "p.fiona112@castle.co"
      fill_in :password, with: "boom"
      fill_in :password_confirmation, with: "boom"

      click_on "Update Profile"
      expect(current_path).to eq("/profile/edit")
      expect(page).to have_content("Email has already been taken")
    end

     it "I can edit my password" do
      click_button "Log In"

      visit "/profile"

      click_on "Change Password"

      expect(current_path).to eq("/profile/edit_password")


      fill_in :new_password, with: "booom"
      fill_in :new_password_confirmation, with: "booom"

      click_on "Update Password"
      expect(page).to have_content("Your password has been updated")
      expect(current_path).to eq("/profile")

    end
  end
end
