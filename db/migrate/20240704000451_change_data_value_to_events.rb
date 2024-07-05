class ChangeDataValueToEvents < ActiveRecord::Migration[6.0]
  def change
    change_column :events, :value, :decimal, precision: 10, scale: 2
    change_column :accounts, :value, :decimal, precision: 10, scale: 2
    change_column :fund_user_histories, :value, :decimal, precision: 10, scale: 2
    change_column :fund_user_histories, :commission, :decimal, precision: 10, scale: 2
    change_column :account_exchanges, :value, :decimal, precision: 10, scale: 2
    add_column :account_exchanges, :to_value, :decimal, precision: 10, scale: 2
  end
end
