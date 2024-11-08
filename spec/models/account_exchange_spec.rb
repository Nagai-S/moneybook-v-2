# == Schema Information
#
# Table name: account_exchanges
#
#  id                 :bigint           not null, primary key
#  date               :date
#  pay_date           :date
#  to_value           :decimal(10, 2)
#  value              :decimal(10, 2)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  card_id            :bigint
#  source_currency_id :bigint
#  source_id          :bigint
#  to_currency_id     :bigint
#  to_id              :bigint
#  user_id            :bigint           not null
#
# Indexes
#
#  index_account_exchanges_on_card_id             (card_id)
#  index_account_exchanges_on_source_currency_id  (source_currency_id)
#  index_account_exchanges_on_source_id           (source_id)
#  index_account_exchanges_on_to_currency_id      (to_currency_id)
#  index_account_exchanges_on_to_id               (to_id)
#  index_account_exchanges_on_user_id             (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (source_currency_id => currencies.id)
#  fk_rails_...  (source_id => accounts.id)
#  fk_rails_...  (to_currency_id => currencies.id)
#  fk_rails_...  (to_id => accounts.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe AccountExchange do
  before do
    @user = create(:user)
    # @user.confirm
    @account1 = @user.accounts.create(name: 'account1', value: 1000)
    @account2 = @user.accounts.create(name: 'account2', value: 1000)
    @card1 =
      @user.cards.create(
        name: 'card1',
        pay_date: 10,
        month_date: 20,
        account_id: @account1.id
      )
  end

  describe "optional validation" do
    it '別のuserのdataを使用してaxを作成できない' do
      different_user = create(:user)
      # different_user.confirm
      new_ax =
        different_user.account_exchanges.build(
          value: 100,
          card_id: nil,
          source_id: @account1.id,
          to_id: @account2.id,
          date: Date.today
        )
      expect(new_ax).to be_invalid
    end    
  end

  describe '#after_change_action' do
    it 'card_id:nilの時' do
      ax =
        @user.account_exchanges.create(
          value: 100,
          card_id: nil,
          source_id: @account1.id,
          to_id: @account2.id,
          date: Date.today
        )
      ax.after_change_action
      expect(ax.card_id).to eq nil
      expect(ax.pay_date).to eq nil
    end

    it 'card_id:not_nil,pay_date:nil,date:todayの時' do
      ax =
        @user.account_exchanges.create(
          value: 100,
          source_id: @card1.account_id,
          card_id: @card1.id,
          to_id: @account2.id,
          date: Date.today
        )
      ax.after_change_action
      expect(ax.card_id).to eq @card1.id
      expect(ax.source_id).to eq @card1.account.id
      expect(ax.pay_date).to eq ax.decide_pay_day
    end

    it 'card_id:not_nil,pay_date:nil,date:1year_agoの時' do
      ax =
        @user.account_exchanges.create(
          value: 100,
          source_id: @card1.account_id,
          card_id: @card1.id,
          to_id: @account2.id,
          date: Date.today.prev_year
        )
      ax.after_change_action
      expect(ax.card_id).to eq @card1.id
      expect(ax.source_id).to eq @card1.account.id
      expect(ax.pay_date).to eq ax.decide_pay_day
    end

    it 'card_id:not_nil,pay_date:last_monthの時' do
      ax =
        @user.account_exchanges.create(
          value: 100,
          source_id: @card1.account_id,
          card_id: @card1.id,
          to_id: @account2.id,
          date: Date.today.prev_year,
          pay_date: Date.today.prev_month.change(day: @card1.pay_date)
        )
      ax.after_change_action
      expect(ax.card_id).to eq @card1.id
      expect(ax.source_id).to eq @card1.account.id
      expect(ax.pay_date).to eq Date.today.prev_month.change(
           day: @card1.pay_date
         )
    end

    it 'card_id:not_nil,pay_date:next_monthの時' do
      ax =
        @user.account_exchanges.create(
          value: 100,
          source_id: @card1.account_id,
          card_id: @card1.id,
          to_id: @account2.id,
          date: Date.today.prev_year,
          pay_date: Date.today.next_month.change(day: @card1.pay_date)
        )
      ax.after_change_action
      expect(ax.card_id).to eq @card1.id
      expect(ax.source_id).to eq @card1.account.id
      expect(ax.pay_date).to eq Date.today.next_month.change(
           day: @card1.pay_date
         )
    end
  end
end
