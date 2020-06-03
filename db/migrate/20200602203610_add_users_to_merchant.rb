class AddUsersToMerchant < ActiveRecord::Migration[5.1]
  def change
    add_reference :merchants, :users, foreign_key: true
  end
end
