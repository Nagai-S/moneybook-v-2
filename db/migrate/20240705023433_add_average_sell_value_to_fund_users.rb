class AddAverageSellValueToFundUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :fund_users, :average_sell_value, :decimal, precision: 10, scale: 2, default: 0
  end
end
