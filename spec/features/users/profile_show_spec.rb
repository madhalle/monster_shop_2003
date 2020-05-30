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

    it "I can see all profile data except for my password" do

      visit "/profile"


      expect(page).to have_content(@user.name)
      expect(page).to have_content(@user.address)
      expect(page).to have_content(@user.city)
      expect(page).to have_content(@user.state)
      expect(page).to have_content(@user.zip)
      expect(page).to have_content(@user.email)
    end

    it "I can see a link to edit my profile data" do

      visit "/profile"

      expect(page).to have_link("Edit Profile")
    end

    it "I can see a link to view 'My Orders'" do 
      visit "/profile"

      click_on "My Orders"

      expect(current_path).to eq("/profile/orders")
    end
  end
end
