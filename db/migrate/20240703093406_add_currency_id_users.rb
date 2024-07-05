class AddCurrencyIdUsers < ActiveRecord::Migration[6.0]
  def change
    add_reference :users, :currency, null: false, default: 1
    User.find_each do |user|
      user.currency_id = 1
      user.save!
    end
  end
end
