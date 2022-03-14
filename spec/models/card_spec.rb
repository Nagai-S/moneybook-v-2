# == Schema Information
#
# Table name: cards
#
#  id         :bigint           not null, primary key
#  month_date :integer
#  name       :string(255)
#  pay_date   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  account_id :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_cards_on_account_id  (account_id)
#  index_cards_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Card do
  before do
    @user = create(:user)
    @user.confirm
    @account1 = @user.accounts.create(name: 'account1', value: 10_000)
    @account2 = @user.accounts.create(name: 'account2', value: 10_000)
    @card =
      @user.cards.create(
        name: 'card1',
        account_id: @account1.id,
        pay_date: 27,
        month_date: 31
      )
    @card_for_destroy =
      @user.cards.create(
        name: 'card_for_destroy',
        account_id: @account2.id,
        pay_date: 27,
        month_date: 31
      )
    @genre_ex = @user.genres.create(iae: false, name: 'genre_ex')
    @genre_in = @user.genres.create(iae: true, name: 'genre_in')
    @event1 =
      @user.events.create(
        iae: false,
        date: Date.today,
        account_id: @card.account_id,
        card_id: @card.id,
        genre_id: @genre_ex.id,
        value: 100,
        memo: ''
      )
    @event1.after_change_action
    @event2 =
      @user.events.create(
        iae: false,
        date: Date.today.prev_month(2),
        account_id: @card.account_id,
        card_id: @card.id,
        genre_id: @genre_ex.id,
        value: 200,
        memo: ''
      )
    @event2.after_change_action
    @event3 =
      @user.events.create(
        iae: false,
        date: Date.today.prev_month(2),
        account_id: @card_for_destroy.account_id,
        card_id: @card_for_destroy.id,
        genre_id: @genre_ex.id,
        value: 200,
        memo: ''
      )
    @event3.after_change_action
    @ax1 =
      @user.account_exchanges.create(
        date: Date.today.prev_month,
        source_id: @card.account_id,
        card_id: @card.id,
        to_id: @account2.id,
        value: 300,
        pon: false,
        pay_date: Date.new(Date.today.year, Date.today.month, 27)
      )
    @ax2 =
      @user.account_exchanges.create(
        date: Date.today.prev_month(2),
        source_id: @card.account_id,
        card_id: @card.id,
        to_id: @account1.id,
        value: 400
      )
    @ax2.after_change_action
    @ax3 =
      @user.account_exchanges.create(
        date: Date.today.prev_month(2),
        source_id: @card_for_destroy.account_id,
        card_id: @card_for_destroy.id,
        to_id: @account1.id,
        value: 400
      )
    @ax3.after_change_action
    @fund = Fund.create(name: 'fund', value: 10_000)
    @fund_user =
      @user.fund_users.create(fund_id: @fund.id, average_buy_value: 9000)
    @fund_user_history1 =
      @fund_user.fund_user_histories.create(
        date: Date.today,
        buy_or_sell: true,
        commission: 150,
        value: 1000,
        account_id: @card.account_id,
        card_id: @card.id
      )
    @fund_user_history1.after_change_action
    @fund_user_history2 =
      @fund_user.fund_user_histories.create(
        date: Date.today.prev_month(3),
        buy_or_sell: true,
        commission: 250,
        value: 2000,
        account_id: @card.account_id,
        card_id: @card.id
      )
    @fund_user_history2.after_change_action
    @fund_user_history3 =
      @fund_user.fund_user_histories.create(
        date: Date.today.prev_month(3),
        buy_or_sell: true,
        commission: 250,
        value: 2000,
        account_id: @card_for_destroy.account_id,
        card_id: @card_for_destroy.id
      )
    @fund_user_history3.after_change_action
  end

  describe 'optional validation' do
    it 'pay_not_equal_to_monthで作成できない' do
      new_card =
        @user.cards.build(
          name: 'card',
          pay_date: 1,
          month_date: 1,
          account_id: @account1.id
        )
      expect(new_card).to be_invalid
    end

    it 'card_name_not_account_nameで作成できない' do
      new_card =
        @user.cards.build(
          name: 'account1',
          pay_date: 10,
          month_date: 1,
          account_id: @account1.id
        )
      expect(new_card).to be_invalid
    end

    it '他のuserはname:account1で作成できる' do
      different_user = create(:user)
      different_user.confirm
      account = different_user.accounts.create(name: 'account',value: 1000)
      new_card =
        different_user.cards.build(
          name: 'account1',
          pay_date: 10,
          month_date: 1,
          account_id: account.id
        )
      expect(new_card).to be_valid
    end

    it '別のuserのアカウントを使用してカードを作成できない' do
      different_user = create(:user)
      different_user.confirm
      new_card =
        different_user.cards.build(
          name: 'card1',
          pay_date: 10,
          month_date: 1,
          account_id: @account1.id
        )
      expect(new_card).to be_invalid
    end
  end

  describe 'for pay_not_for_card' do
    it '#not_pay_dates' do
      expect(@card.not_pay_dates).to eq [
           Date.new(Date.today.year, Date.today.month, 27),
           Date.today.next_month.change(day: 27)
         ]
    end

    it 'not_pay_value' do
      expect(
        @card.not_pay_value(Date.new(Date.today.year, Date.today.month, 27))
      ).to eq 300
      expect(
        @card.not_pay_value(Date.today.next_month.change(day: 27))
      ).to eq 1100
    end
  end

  describe 'with_controller' do
    it '#after_update_action' do
      @card.update(account_id: @account2.id, pay_date: 1)
      @card.after_update_action
      expect(Event.find(@event1.id).pay_date).to eq Date
           .today
           .next_month
           .change(day: 1)
      expect(Event.find(@event1.id).account_id).to eq @account2.id
      expect(Event.find(@event2.id).pay_date).to eq Date
           .today
           .prev_month
           .change(day: 27)
      expect(Event.find(@event2.id).account_id).to eq @account1.id
      expect(AccountExchange.find(@ax1.id).pay_date).to eq Date.new(
           Date.today.year,
           Date.today.month,
           1
         )
      expect(AccountExchange.find(@ax1.id).pon).to eq true
      expect(AccountExchange.find(@ax1.id).source_id).to eq @account2.id
      expect(AccountExchange.find(@ax2.id).pay_date).to eq Date
           .today
           .prev_month
           .change(day: 27)
      expect(AccountExchange.find(@ax2.id).source_id).to eq @account1.id
      expect(FundUserHistory.find(@fund_user_history1.id).pay_date).to eq Date
           .today
           .next_month
           .change(day: 1)
      expect(
        FundUserHistory.find(@fund_user_history1.id).account_id
      ).to eq @account2.id
      expect(FundUserHistory.find(@fund_user_history2.id).pay_date).to eq Date
           .today
           .prev_month(2)
           .change(day: 27)
      expect(
        FundUserHistory.find(@fund_user_history2.id).account_id
      ).to eq @account1.id
    end

    it '#before_destroy_action' do
      @card_for_destroy.before_destroy_action
      expect(Event.find(@event3.id).card_id).to eq nil
      expect(Event.find(@event3.id).account_id).to eq @card_for_destroy
           .account_id
      expect(AccountExchange.find(@ax3.id).card_id).to eq nil
      expect(AccountExchange.find(@ax3.id).source_id).to eq @card_for_destroy
           .account_id
      expect(FundUserHistory.find(@fund_user_history3.id).card_id).to eq nil
      expect(
        FundUserHistory.find(@fund_user_history3.id).account_id
      ).to eq @card_for_destroy.account_id
    end
  end
end
