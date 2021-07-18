class AddIdToFund < ActiveRecord::Migration[6.0]
  def change
    add_column :funds, :string_id, :string
  end
end
