# == Schema Information
#
# Table name: fund_user_histories
#
#  id           :bigint           not null, primary key
#  buy_date     :date
#  buy_or_sell  :boolean          default(TRUE)
#  commission   :integer
#  date         :date
#  pay_date     :date
#  value        :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  account_id   :bigint
#  card_id      :bigint
#  fund_user_id :bigint           not null
#
# Indexes
#
#  index_fund_user_histories_on_account_id    (account_id)
#  index_fund_user_histories_on_card_id       (card_id)
#  index_fund_user_histories_on_fund_user_id  (fund_user_id)
#
# Foreign Keys
#
#  fk_rails_...  (fund_user_id => fund_users.id)
#
require 'rails_helper'

RSpec.describe FundUserHistory do
  before do
    @user = create(:user)
    @user.confirm
    @account1 = @user.accounts.create(name: 'account1', value: 1000)
    @card1 =
      @user.cards.create(
        name: 'card1',
        pay_date: 10,
        month_date: 20,
        account_id: @account1.id
      )
    @fund = Fund.create(name: 'fund1', value: 10_000)
    @fund_user =
      @user.fund_users.create(fund_id: @fund.id, average_buy_value: 9000)
  end

  describe "optional validation" do
    it '別のuserのdataを使用してfuhを作成できない' do
      different_user = create(:user)
      different_user.confirm
      dif_fund_user = different_user.fund_users.create(fund_id: @fund.id, average_buy_value: 9000)
      fuh =
        dif_fund_user.fund_user_histories.build(
          value: 1000,
          commission: 100,
          card_id: nil,
          account_id: @account1.id,
          date: Date.today,
          buy_or_sell: false
        )
        expect(fuh).to be_invalid
    end    
  end

  describe 'with controller' do
    describe '#after_change_action' do
      it 'card_id:nilの時' do
        fuh =
          @fund_user.fund_user_histories.create(
            value: 1000,
            commission: 100,
            card_id: nil,
            account_id: @account1.id,
            date: Date.today,
            buy_or_sell: false
          )
        fuh.after_change_action
        expect(fuh.account_id).to eq @account1.id
        expect(fuh.card_id).to eq nil
        expect(fuh.pay_date).to eq nil
      end

      it 'card_id:not_nil,pay_date:nil,date:todayの時' do
        fuh =
          @fund_user.fund_user_histories.create(
            value: 1000,
            commission: 100,
            account_id: @card1.account_id,
            card_id: @card1.id,
            date: Date.today,
            buy_or_sell: true
          )
        fuh.after_change_action
        expect(fuh.card_id).to eq @card1.id
        expect(fuh.account_id).to eq @card1.account_id
        expect(fuh.pay_date).to eq fuh.decide_pay_day
      end

      it 'card_id:not_nil,pay_date:nil,date:1year_agoの時' do
        fuh =
          @fund_user.fund_user_histories.create(
            value: 1000,
            commission: 100,
            account_id: @card1.account_id,
            card_id: @card1.id,
            date: Date.today.prev_year,
            buy_date: Date.today.prev_year,
            buy_or_sell: true
          )
        fuh.after_change_action
        expect(fuh.card_id).to eq @card1.id
        expect(fuh.account_id).to eq @card1.account_id
        expect(fuh.pay_date).to eq fuh.decide_pay_day
      end

      it 'card_id:not_nil,pay_date:last_monthの時' do
        fuh =
          @fund_user.fund_user_histories.create(
            value: 1000,
            commission: 100,
            account_id: @card1.account_id,
            card_id: @card1.id,
            buy_or_sell: true,
            date: Date.today.prev_year,
            buy_date: Date.today.prev_year,
            pay_date: Date.today.prev_month.change(day: @card1.pay_date)
          )
        fuh.after_change_action
        expect(fuh.card_id).to eq @card1.id
        expect(fuh.account_id).to eq @card1.account_id
        expect(fuh.pay_date).to eq Date.today.prev_month.change(
             day: @card1.pay_date
           )
      end

      it 'card_id:not_nil,pay_date:next_monthの時' do
        fuh =
          @fund_user.fund_user_histories.create(
            value: 1000,
            commission: 100,
            account_id: @card1.account_id,
            card_id: @card1.id,
            date: Date.today.prev_year,
            buy_date: Date.today.prev_year,
            buy_or_sell: true,
            pay_date: Date.today.next_month.change(day: @card1.pay_date)
          )
        fuh.after_change_action
        expect(fuh.card_id).to eq @card1.id
        expect(fuh.account_id).to eq @card1.account_id
        expect(fuh.pay_date).to eq Date.today.next_month.change(
             day: @card1.pay_date
           )
      end
    end
  end
end
