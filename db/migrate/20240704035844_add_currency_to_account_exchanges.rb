class AddCurrencyToAccountExchanges < ActiveRecord::Migration[6.0]
  def change
    remove_column :account_exchanges, :to_currency_id
    remove_column :account_exchanges, :source_currency_id
    # add_reference :account_exchanges, :to_currency, foreign_key: {to_table: :currencies}
    # add_reference :account_exchanges, :source_currency, foreign_key: {to_table: :currencies}
    # AccountExchange.find_each do |ax|
    #   ax.to_currency_id = 1
    #   ax.source_currency_id = 1
    #   ax.save!
    # end
  end
end
