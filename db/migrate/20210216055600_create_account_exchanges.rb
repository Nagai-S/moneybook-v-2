class CreateAccountExchanges < ActiveRecord::Migration[6.0]
  def change
    create_table :account_exchanges do |t|
      t.references :user, null: false, foreign_key: true
      t.date :date
      t.integer :value
      t.boolean :pon
      t.date :pay_date
      t.references :card
      t.references :source, foreign_key: {to_table: :accounts}
      t.references :to, foreign_key: {to_table: :accounts}

      t.timestamps
    end
  end
end
