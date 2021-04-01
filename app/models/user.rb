class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable, :confirmable
  include DeviseTokenAuth::Concerns::User

  has_many :events, dependent: :delete_all
  has_many :account_exchanges, dependent: :delete_all
  has_many :genres, dependent: :delete_all
  has_many :cards, dependent: :delete_all
  has_many :accounts, dependent: :delete_all

  def after_pay_value
    not_pay_value=self.account_exchanges.where(pon: false).sum(:value)+self.events.where(pon: false).sum(:value)
    return self.accounts.sum(:value)-not_pay_value
  end

  def how_long_months_years
    first_date=self.events.first.date
    last_date=self.events.last.date
    months=(first_date.year-1-last_date.year)*12+first_date.month+12-last_date.month+1
    years=(first_date.year-last_date.year+1)
    return {months: months, years: years}
  end

end
