class Card < ApplicationRecord
  belongs_to :user
  belongs_to :account
  has_many :events
  has_many :account_exchanges

  validates :name, presence: {message: "は１文字以上入力してください。"}, 
  uniqueness: { scope: :user, message: "「%{value}」と同じ名前のカードが存在します。" }
  validates :pay_date, presence: true,
  numericality: {
    only_integer: true,
    greater_than_or_equal_to: 1,
    less_than_or_equal_to: 31
  }
  validates :month_date, presence: true,
  numericality: {
    only_integer: true,
    greater_than_or_equal_to: 1,
    less_than_or_equal_to: 31,
  }
  validate :pay_not_equal_to_month, :card_name_not_account_name

  def before_destroy_action
    self.events.each do |event|
      event.update(card_id: nil, account_id: self.account.id, pay_date: nil)
    end
    self.account_exchanges.each do |ax|
      ax.update(card_id: nil, source_id: self.account.id, pay_date: nil)
    end
  end

  def months_count_for_not_pay
    first_date_event=self.events.where(pon: false).first.pay_date if self.events.where(pon: false).first
    last_date_event=self.events.where(pon: false).last.pay_date if self.events.where(pon: false).last
    first_date_ax=self.account_exchanges.where(pon: false).first.pay_date if self.account_exchanges.where(pon: false).first
    last_date_ax=self.account_exchanges.where(pon: false).last.pay_date if self.account_exchanges.where(pon: false).last

    if first_date_event && first_date_ax
      first_date= first_date_event>first_date_ax ? first_date_event : first_date_ax
    elsif first_date_event
      first_date=first_date_event
    elsif first_date_ax
      first_date=first_date_ax
    end

    if last_date_event && last_date_ax
      last_date= last_date_event>last_date_ax ? last_date_event : last_date_ax
    elsif last_date_event
      last_date=last_date_event
    elsif last_date_ax
      last_date=last_date_ax
    end
    months=(first_date.year-1-last_date.year)*12+first_date.month+12-last_date.month+1
    return months
  end

  def not_pay_value(pay_date)
    event=self.events.where(pon: false, pay_date: pay_date).sum(:value)
    ax=self.account_exchanges.where(pon: false, pay_date: pay_date).sum(:value)
    return event+ax
  end

  def before_update_action
    self.events.each do |event|
      event.update(pay_date: event.decide_pay_day)
      event.change_pon
    end
    self.account_exchanges.each do |ax|
      ax.update(pay_date: ax.decide_pay_day)
      ax.change_pon
    end
  end
  

  private
    def pay_not_equal_to_month
      if pay_date==month_date
        errors.add(:month_date, "と引き落とし日を別にしてください。")
      end
    end

    def card_name_not_account_name
      Account.all.each do |account|
        if account.name==name
          errors.add(:name, "はアカウントでも使用されているので使えません。")
        end
      end  
    end
    
end
