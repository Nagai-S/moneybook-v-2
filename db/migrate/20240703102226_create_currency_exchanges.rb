class CreateCurrencyExchanges < ActiveRecord::Migration[6.0]
  def change
    create_table :currency_exchanges do |t|
      t.references :unit, null: false, foreign_key: {to_table: :currencies}
      t.references :to, null: false, foreign_key: {to_table: :currencies}

      t.timestamps
    end
  end
end
