class RemovePonFromAccountExchange < ActiveRecord::Migration[6.0]
  def change
    remove_column :account_exchanges, :pon, :boolean
  end
end
