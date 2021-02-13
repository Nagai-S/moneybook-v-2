class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  has_many :accounts, dependent: :destroy

  def total_value
    sum=0
    self.accounts.each do |account|
      sum+=account.value
    end
    return sum
  end
  
end
