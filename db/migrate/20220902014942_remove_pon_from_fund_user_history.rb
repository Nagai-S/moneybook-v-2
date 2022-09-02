class RemovePonFromFundUserHistory < ActiveRecord::Migration[6.0]
  def change
    remove_column :fund_user_histories, :pon, :boolean
  end
end
