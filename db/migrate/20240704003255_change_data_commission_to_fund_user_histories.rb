class ChangeDataCommissionToFundUserHistories < ActiveRecord::Migration[6.0]
  def change
    change_column :fund_user_histories, :commission, :decimal, precision: 10, scale: 2, default: 0
  end
end
