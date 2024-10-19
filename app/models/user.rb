# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  confirmation_sent_at   :datetime
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  provider               :string(255)      default("email"), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string(255)
#  tokens                 :text(65535)
#  uid                    :string(255)      default(""), not null
#  unconfirmed_email      :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  currency_id            :bigint           default(1), not null
#
# Indexes
#
#  index_users_on_currency_id           (currency_id)
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_uid_and_provider      (uid,provider) UNIQUE
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable
        #  :confirmable
  include DeviseTokenAuth::Concerns::User

  belongs_to :currency
  has_many :events, dependent: :delete_all
  has_many :shortcuts, dependent: :delete_all
  has_many :account_exchanges, dependent: :delete_all
  has_many :genres, dependent: :delete_all
  has_many :cards, dependent: :delete_all
  has_many :accounts, dependent: :delete_all
  has_many :fund_users, dependent: :delete_all
  has_many :funds, through: :fund_users

  def scale_factor(curr)
    return currency_id == curr.id ? 1 : curr.scale_to(self.currency)
  end

  def income_expense_for_duration(time_duration)
    in_total = 0;
    ex_total = 0;
    events_for_time = events.where(date: time_duration)
    return calculate_in_ex_for_events(events_for_time)
  end

  def calculate_in_ex_for_events(arg_events)
    in_total = 0;
    ex_total = 0;

    events_with_current_currency = arg_events.where(currency_id: currency_id)
    in_total += events_with_current_currency.where(iae: true).sum(:value)
    ex_total += events_with_current_currency.where(iae: false).sum(:value)

    used_currencies.each do |curr|
      events_with_different_currency = arg_events
        .where.not(currency_id: currency_id)
        .where(pay_currency_id: curr.id)
      in_total += events_with_different_currency.where(iae: true).sum(:pay_value) * scale_factor(curr)
      ex_total += events_with_different_currency.where(iae: false).sum(:pay_value) * scale_factor(curr)
    end

    return { in: in_total, ex: ex_total, plus_minus: in_total + ex_total }
  end

  def total_account_value
    return_value = 0
    accounts.each do |account|
      return_value += account.now_value({scale: true})
    end
    return return_value
  end

  def after_pay_value
    return_value = 0
    accounts.each { |account| return_value += account.after_pay_value({scale: true}) }
    return return_value
  end

  def how_long_months_years
    first_date = events.first.date
    last_date = events.last.date
    months =
      (first_date.year - 1 - last_date.year) * 12 + first_date.month + 12 -
        last_date.month + 1
    years = (first_date.year - last_date.year + 1)
    return { months: months, years: years }
  end

  def total_fund_value
    return_value = 0
    fund_users.each { |fund_user| return_value += fund_user.now_value({scale: true}) }
    return return_value
  end

  def total_fund_gain_value
    return_value = 0
    fund_users.each { |fund_user| return_value += fund_user.gain_value({scale: true}) }
    return return_value
  end

  def total_assets
    total_account_value + total_fund_value
  end

  def total_after_pay_assets
    after_pay_value + total_fund_value
  end

  def used_currencies
    currencies = accounts.where.not(currency_id: nil).map(&:currency)
    uniq_currencies = currencies.uniq(&:id)
    return uniq_currencies
  end
end
