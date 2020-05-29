require 'rails_helper'

RSpec.describe "when a user visits the log out path" do
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
  it "they will be redirected to the welcome/home page" do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@registered_user)
    visit '/login'

    fill_in :email, with:"bigshrek12@castle.co"
    fill_in :password, with:"boom"

    click_button "Log In"


    click_link "Log Out"
    expect(current_path).to eq("/")

    # visit "/logout"
    expect(page).to have_content("You have been logged out")
    expect(page).to have_content("Cart: 0")

  end
  # ```
  # [ ] done
  #
  # User Story 16, User can log out
  #
  # As a registered user, merchant, or admin
  # When I visit the logout path
  # I am redirected to the welcome / home page of the site
  # And I see a flash message that indicates I am logged out
  # Any items I had in my shopping cart are deleted
  # ```
end
