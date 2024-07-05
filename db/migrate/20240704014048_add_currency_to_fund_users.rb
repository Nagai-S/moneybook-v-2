class AddCurrencyToFundUsers < ActiveRecord::Migration[6.0]
  def change
    add_reference :fund_users, :currency, null: false
    FundUser.find_each do |fu|
      fu.currency_id = 1
      fu.save!
    end
  end
end
