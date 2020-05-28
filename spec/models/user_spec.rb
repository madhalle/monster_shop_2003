require 'rails_helper'

describe User, type: :model do
  describe "roles" do
    it "can be created as an admin" do
      user = User.create(name: "Fiona",
                         address: "123 Top Of The Tower",
                         city: "Duloc City",
                         state: "Duloc State",
                         zip: 10001,
                         email: "p.fiona12@castle.co",
                         password: "boom",
                         role: 2)

      expect(user.role).to eq("admin")
      expect(user.admin?).to be_truthy
    end

    it "can be created as a default user" do
      user = User.create(name: "Fiona",
                         address: "123 Top Of The Tower",
                         city: "Duloc City",
                         state: "Duloc State",
                         zip: 10001,
                         email: "p.fiona12@castle.co",
                         password: "boom",
                         role: 0)

      expect(user.role).to eq("user")
      expect(user.user?).to be_truthy
    end

    it "can be created as a merchant user" do
      user = User.create(name: "Fiona",
                         address: "123 Top Of The Tower",
                         city: "Duloc City",
                         state: "Duloc State",
                         zip: 10001,
                         email: "p.fiona12@castle.co",
                         password: "boom",
                         role: 1)

      expect(user.role).to eq("merchant")
      expect(user.merchant?).to be_truthy
    end
  end

  describe "validations" do
    it {should validate_presence_of(:name)}
    it {should validate_presence_of(:address)}
    it {should validate_presence_of(:city)}
    it {should validate_presence_of(:state)}
    it {should validate_presence_of(:zip)}
    it {should validate_uniqueness_of(:email)}
    it {should validate_presence_of(:password)}
  end

  describe "methods" do
    it "#unique_email?" do
      user1 = User.create(name: "Fiona",
                         address: "123 Top Of The Tower",
                         city: "Duloc City",
                         state: "Duloc State",
                         zip: 10001,
                         email: "p.fiona12@castle.co",
                         password: "boom",
                         role: 1)
      user2 = User.create(name: "Fiona",
                         address: "123 Top Of The Tower",
                         city: "Duloc City",
                         state: "Duloc State",
                         zip: 10001,
                         email: "p.fiona12@castle2.co",
                         password: "boom",
                         role: 1)

      email = "gingerbread_man@gmail.com"

      expect(User.unique_email?(email)).to eq(true)
      expect(User.unique_email?(user1.email)).to eq(false)
    end
  end
end
