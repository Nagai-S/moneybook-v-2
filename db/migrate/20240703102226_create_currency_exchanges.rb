class CreateCurrencyExchanges < ActiveRecord::Migration[6.0]
  def change
    create_table :currency_exchanges do |t|
      t.references :unit, null: false, foreign_key: {to_table: :currencies}
      t.references :to, null: false, foreign_key: {to_table: :currencies}

      t.timestamps
    end
    CurrencyExchange.create(unit_id: 1, to_id: 2)
    CurrencyExchange.create(unit_id: 2, to_id: 1)
  end
end
