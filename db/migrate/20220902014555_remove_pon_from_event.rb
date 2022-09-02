class RemovePonFromEvent < ActiveRecord::Migration[6.0]
  def change
    remove_column :events, :pon, :boolean
  end
end
