class AddColumnBuyDateToFundUserHistories < ActiveRecord::Migration[6.0]
  def change
    add_column :fund_user_histories, :buy_date, :date
    FundUserHistory.find_each do |fuh|
      fuh.buy_date = fuh.date      
      fuh.save!
    end
  end
end
