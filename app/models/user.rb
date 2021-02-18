class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  has_many :accounts, dependent: :destroy
  has_many :genres, dependent: :destroy
  has_many :cards, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :account_exchanges, dependent: :destroy

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

  def make_sure_pay_date_and_pon
    self.events.where(pon: false).includes(:card, :account).each do |event|
      event.change_pon
    end
    self.account_exchanges.where(pon: false).includes(:card, :account).each do |ax|
      ax.change_pon
    end
  end
  
end
