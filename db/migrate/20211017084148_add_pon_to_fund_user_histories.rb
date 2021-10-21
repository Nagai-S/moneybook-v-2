class AddPonToFundUserHistories < ActiveRecord::Migration[6.0]
  def change
    add_column :fund_user_histories, :pon, :boolean, default: false
  end
end
