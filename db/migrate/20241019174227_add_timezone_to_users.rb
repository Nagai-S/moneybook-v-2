class AddTimezoneToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :timezone, :string
    User.find_each do |user|
      user.timezone = "Asia/Tokyo"
      user.save!
    end
  end
end
