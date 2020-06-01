require 'rails_helper'

RSpec.describe 'user new page', type: :feature do
  describe 'As a visitor' do
    it 'I can create a new user' do
      visit '/'
      click_link 'Register'

      expect(current_path).to eq('/register')

      name = 'Gingerbread Man'
      address = '123 Oven Circle'
      city = 'Duloc City'
      state = 'Duloc State'
      zip = 10001
      email = 'gingerbread.man@sweets.com'
      password = 'MyPassword!'

      fill_in :name, with: name
      fill_in :address, with: address
      fill_in :city, with: city
      fill_in :state, with: state
      fill_in :zip, with: zip
      fill_in :email, with: email
      fill_in :password, with: password
      fill_in :password_confirmation, with: password

      click_button 'Create User'

      new_user = User.last

      expect(current_path).to eq('/profile')
      expect(page).to have_content('Success! You are now registered and logged in as a User!')
      expect(new_user.name).to eq(name)
      expect(new_user.address).to eq(address)
      expect(new_user.city).to eq(city)
      expect(new_user.state).to eq(state)
      expect(new_user.zip).to eq(zip)
      expect(new_user.email).to eq(email)
    end

    it 'I cant create a user if all fields are not filled in' do
      visit '/register'

      name = 'Gingerbread Man'
      address = '123 Oven Circle'
      city = 'Duloc City'
      state = 'Duloc State'
      email = 'gingerbread.man@sweets.com'
      password = 'MyPassword!'

      fill_in :name, with: name
      fill_in :address, with: address
      fill_in :city, with: city
      fill_in :state, with: state
      fill_in :zip, with: ""
      fill_in :email, with: email
      fill_in :password, with: password
      fill_in :password_confirmation, with:""

      click_button 'Create User'

      expect(page).to have_content("Password confirmation doesn't match Password and Zip can't be blank")
    end

    it "Email must be unique to register" do

      user = User.create!(name: "Fiona",
                         address: "123 Top Of The Tower",
                         city: "Duloc City",
                         state: "Duloc State",
                         zip: 10001,
                         email: 'gingerbread.man@sweets.com',
                         password: "boom",
                         role: 1)

      name = 'Gingerbread Man'
      address = '123 Oven Circle'
      city = 'Duloc City'
      state = 'Duloc State'
      zip = 10001
      email = 'gingerbread.man@sweets.com'
      password = 'MyPassword!'

      unique_email = 'gingerbread.man2@sweets.com'
      visit '/register'

      fill_in :name, with: name
      fill_in :address, with: address
      fill_in :city, with: city
      fill_in :state, with: state
      fill_in :zip, with: zip
      fill_in :email, with: email
      fill_in :password, with: password
      fill_in :password_confirmation, with: password

      click_button "Create User"

      expect(page).to have_content("Email has already been taken")

      fill_in :email, with: unique_email
      fill_in :password, with: password
      fill_in :password_confirmation, with: password
      click_button "Create User"

      new_user = User.last

      expect(current_path).to eq('/profile')
      expect(page).to have_content('Success! You are now registered and logged in as a User!')
      expect(new_user.name).to eq(name)
      expect(new_user.address).to eq(address)
      expect(new_user.city).to eq(city)
      expect(new_user.state).to eq(state)
      expect(new_user.zip).to eq(zip)
      expect(new_user.email).to eq(unique_email)
    end
  end
end
