class AddCurrencyIdToAccounts < ActiveRecord::Migration[6.0]
  def change
    add_reference :accounts, :currency, null: false
    Account.find_each do |account|
      account.currency_id = 1
      account.save!
    end
  end
end
