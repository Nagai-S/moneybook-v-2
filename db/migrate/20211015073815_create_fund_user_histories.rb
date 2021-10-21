class CreateFundUserHistories < ActiveRecord::Migration[6.0]
  def change
    create_table :fund_user_histories do |t|
      t.references :account, null: true
      t.references :card, null: true
      t.date :pay_date
      t.boolean :buy_or_sell, default: true
      t.integer :value
      t.integer :commission
      t.references :fund_user, null: false, foreign_key: true
      t.date :date

      t.timestamps
    end
  end
end
