class AddValueToCurrencyExchanges < ActiveRecord::Migration[6.0]
  def change
    add_column :currency_exchanges, :value, :float
  end
end
