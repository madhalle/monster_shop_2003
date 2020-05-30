require "rails_helper"

describe "As a default user" do
  describe "when I visit my profile/orders page" do

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

    it "I can see every order I've made" do
      binding.pry
    end
  end
end
