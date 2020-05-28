
require 'rails_helper'

RSpec.describe 'Site Navigation', type: :feature do
  describe 'As a Visitor' do
    it "I see a nav bar with links to all pages" do
      visit '/merchants'

      within 'nav' do
        click_link 'All Items'
      end

      expect(current_path).to eq('/items')

      within 'nav' do
        click_link 'All Merchants'
      end

      expect(current_path).to eq('/merchants')

      within 'nav' do
        click_link 'Home'
      end

      expect(current_path).to eq('/')

      within 'nav' do
        click_link 'Log in'
      end

      expect(current_path).to eq('/login')

      within 'nav' do
        click_link 'Register'
      end

      expect(current_path).to eq('/register')

      within 'nav' do
        click_link 'Cart: 0'
      end

      expect(current_path).to eq('/cart')

      within 'nav' do
        expect(page).to_not have_link("Dashboard")
      end
    end

    it "I can see a cart indicator on all pages" do
      visit '/merchants'

      within 'nav' do
        expect(page).to have_content("Cart: 0")
      end

      visit '/items'

      within 'nav' do
        expect(page).to have_content("Cart: 0")
      end

    end

  end

  describe 'As a Admin' do

    it "I see a nav bar with links to all pages" do
      admin = User.create(name: "Lord Farquaad",
                          address: "123 Castle Lane",
                          city: "Duloc City",
                          state: "Duloc State",
                          zip: 10001,
                          email: "lord.farquaad@castle.org",
                          password: "Password",
                          role: 2)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

      visit '/merchants'

      within 'nav' do
        click_link 'All Items'
      end

      expect(current_path).to eq('/items')

      within 'nav' do
        click_link 'All Merchants'
      end

      expect(current_path).to eq('/merchants')

      within 'nav' do
        click_link 'Home'
      end

      expect(current_path).to eq('/')

      within 'nav' do
        click_link 'Log in'
      end

      expect(current_path).to eq('/login')

      within 'nav' do
        click_link 'Register'
      end

      expect(current_path).to eq('/register')
    end

    it "I see admin specific links on the nav bar" do
      admin = User.create(name: "Lord Farquaad",
                          address: "123 Castle Lane",
                          city: "Duloc City",
                          state: "Duloc State",
                          zip: 10001,
                          email: "lord.farquaad@castle.gov",
                          password: "Password",
                          role: 2)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

      visit '/merchants'

      within 'nav' do
        click_link "Dashboard"
      end

      expect(current_path).to eq('/admin')

      within 'nav' do
        click_link "All Users"
      end

      expect(current_path).to eq('/admin/users')

      within 'nav' do
        expect(page).to_not have_content('Cart: 0')
      end
    end
  end

  describe 'As a Visitor' do
    it "I receive 404 errors when trying to access restricted paths" do
      visit "/merchant"
      expect(page).to have_content("The page you were looking for doesn't exist (404)")

      visit "/admin"
      expect(page).to have_content("The page you were looking for doesn't exist (404)")

      visit "/profile"
      expect(page).to have_content("The page you were looking for doesn't exist (404)")
    end
  end
end
