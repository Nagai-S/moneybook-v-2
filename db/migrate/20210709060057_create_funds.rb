class CreateFunds < ActiveRecord::Migration[6.0]
  def change
    create_table :funds do |t|
      t.integer :value
      t.string :name
      t.date :update_on

      t.timestamps
    end
  end
end
