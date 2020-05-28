
require 'rails_helper'

RSpec.describe 'Site Navigation' do
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
    end

    describe 'As a Merchant Employee' do
      it 'I see a nav bar with the same links as a user, plus a link to the merchant dashboard' do

        merchant = User.create!(name: "Fiona",
                           address: "123 Top Of The Tower",
                           city: "Duloc City",
                           state: "Duloc State",
                           zip: 10001,
                           email: "p.fiona12@castle.co",
                           password: "boom",
                           role: 1)

        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)
        
        visit '/merchants'

        within 'nav' do
          click_link 'Dashboard'
        end

        expect(current_path).to eq('/merchant')
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
end
