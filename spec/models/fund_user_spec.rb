2# == Schema Information
#
# Table name: fund_users
#
#  id                :bigint           not null, primary key
#  average_buy_value :decimal(10, 2)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  fund_id           :bigint           not null
#  user_id           :bigint           not null
#
# Indexes
#
#  index_fund_users_on_fund_id  (fund_id)
#  index_fund_users_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (fund_id => funds.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe FundUser do
  before do
    @user = create(:user)
    @user.confirm
    @account = @user.accounts.create(
      value: 10000,
      name: "account1"
    )
    @account_for_card = @user.accounts.create(
      value: 10000,
      name: "account_for_card"
    )
    @card = @user.cards.create(
      name: "card1", 
      pay_date: 10, 
      month_date: 20, 
      account_id: @account_for_card.id
    )
    @fund_with_value = Fund.create(
      name: "fund1",
      value: 10000,
    )
    @fund_no_value = Fund.create(
      name: "fund2",
    )
    @fund_user1 = @user.fund_users.create(
      average_buy_value: 9000,
      fund_id: @fund_with_value.id
    )
    @fund_user2 = @user.fund_users.create(
      average_buy_value: 9000,
      fund_id: @fund_no_value.id
    )

    @fund_user_history1_1 = @fund_user1.fund_user_histories.create(
      buy_or_sell: true,
      commission: 100,
      date: Date.today,
      pon: true,
      value: 1000,
      account_id: @account.id,
    )
    @fund_user_history1_2 = @fund_user1.fund_user_histories.create(
      buy_or_sell: false,
      commission: 100,
      date: Date.today,
      pon: true,
      value: 300,
      account_id: @account.id,
    )
    @fund_user_history2_1 = @fund_user2.fund_user_histories.create(
      buy_or_sell: true,
      commission: 100,
      date: Date.today,
      pon: true,
      value: 1000,
      account_id: @account.id,
    )
    @fund_user_history2_2 = @fund_user2.fund_user_histories.create(
      buy_or_sell: false,
      commission: 100,
      date: Date.today,
      pon: true,
      value: 300,
      account_id: @account.id,
    )
  end

  describe "#now_value" do
    it "fundのvalueがある時" do
      expect(@fund_user1.now_value).to eq ((900.to_f*10000.to_f/9000.to_f) - 300).round
    end
    
    it "fundのvalueがない時" do
      expect(@fund_user2.now_value).to eq 600.to_f.round
    end
  end
end
