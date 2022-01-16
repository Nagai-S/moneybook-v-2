# == Schema Information
#
# Table name: accounts
#
#  id         :bigint           not null, primary key
#  name       :string(255)
#  value      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_accounts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Account do
  before do
    @user = create(:user)
    @user.confirm
    @account1 = @user.accounts.create(name: 'account1', value: 1000)
    @account2 = @user.accounts.create(name: 'account2', value: 1000)
    @card =
      @user.cards.create(
        name: 'card1',
        pay_date: 1,
        month_date: 20,
        account_id: @account2.id
      )
    @genre_ex = @user.genres.create(iae: false, name: 'genre_ex')
    @genre_in = @user.genres.create(iae: true, name: 'genre_in')
    @event1 =
      @user.events.create(
        iae: true,
        date: Date.today,
        account_id: @account1.id,
        card_id: nil,
        genre_id: @genre_in.id,
        value: 100,
        memo: ''
      )
    @event1.after_change_action
    @event2 =
      @user.events.create(
        iae: false,
        date: Date.today,
        account_id: @card.account_id,
        card_id: @card.id,
        genre_id: @genre_ex.id,
        value: 200,
        memo: ''
      )
    @event2.after_change_action
    @ax1 =
      @user.account_exchanges.create(
        date: Date.today,
        source_id: @account1.id,
        card_id: nil,
        to_id: @account2.id,
        value: 300
      )
    @ax1.after_change_action
    @ax2 =
      @user.account_exchanges.create(
        date: Date.today,
        source_id: @card.account_id,
        card_id: @card.id,
        to_id: @account1.id,
        value: 400
      )
    @ax2.after_change_action
    @fund = Fund.create(name: 'fund', value: 10_000)
    @fund_user =
      @user.fund_users.create(fund_id: @fund.id, average_buy_value: 11_000)
    @fund_user_history1 =
      @fund_user.fund_user_histories.create(
        date: Date.today,
        buy_or_sell: false,
        commission: 150,
        value: 1000,
        account_id: @account1.id,
        card_id: nil
      )
    @fund_user_history1.after_change_action
    @fund_user_history2 =
      @fund_user.fund_user_histories.create(
        date: Date.today,
        buy_or_sell: true,
        commission: 250,
        value: 2000,
        account_id: @card.account_id,
        card_id: @card.id
      )
    @fund_user_history2.after_change_action
  end

  it '#now_value' do
    expect(@account1.now_value).to eq 1000 + 100 - 300 + 400 + 1000 - 150
    expect(@account2.now_value).to eq 1000 + 300
  end

  it '#after_pay_value' do
    expect(@account1.after_pay_value).to eq @account1.now_value
    expect(@account2.after_pay_value).to eq 1000 - 200 + 300 - 400 - 2000
  end

  it '#before_destroy_action' do
    @account1.before_destroy_action
    expect(Event.find(@event1.id).account_id).to eq nil
    expect(AccountExchange.find(@ax1.id).source_id).to eq nil
    expect(AccountExchange.find(@ax2.id).to_id).to eq nil
    expect(FundUserHistory.find(@fund_user_history1.id).account_id).to eq nil
  end
end
