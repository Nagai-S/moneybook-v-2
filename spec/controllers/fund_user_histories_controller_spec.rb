require 'rails_helper'

RSpec.describe FundUserHistoriesController do
  before do
    @user = create(:user)
    @user.confirm
    sign_in @user

    @account1 = @user.accounts.create(value: 10_000, name: 'account1')
    @account2 = @user.accounts.create(value: 20_000, name: 'account2')
    @card1 =
      @user.cards.create(
        name: 'card1',
        pay_date: 10,
        month_date: 20,
        account_id: @account1.id
      )
    @fund = Fund.create(name: 'fund1', value: 10_000)
    @fund_user =
      @user.fund_users.create(average_buy_value: 9000, fund_id: @fund.id)
  end

  describe 'create' do
    let(:params) do
      {
        fund_user_history: {
          'date(1i)' => Date.today.year,
          'date(2i)' => Date.today.month,
          'date(3i)' => Date.today.day,
          'buy_date(1i)' => Date.today.year,
          'buy_date(2i)' => Date.today.month,
          'buy_date(3i)' => Date.today.day,
          :value => 1000,
          :commission => 100
        },
        fund_user_id: @fund_user.id
      }
    end
    describe 'association_model_update' do
      it '正しいaccountで登録される' do
        params[:fund_user_history][:account_or_card] = '0'
        params[:fund_user_history][:account_id] = @account1.id
        params[:fund_user_history][:card_id] = @card1.id
        params[:fund_user_history][:buy_or_sell] = false

        expect { post :create, params: params }.to change {
          FundUserHistory.all.length
        }.by(1)
        expect(FundUserHistory.order(:id).last.account_id).to eq @account1.id
        expect(FundUserHistory.order(:id).last.card_id).to eq nil
      end

      it '正しいcardで登録される' do
        params[:fund_user_history][:account_or_card] = '1'
        params[:fund_user_history][:account_id] = @account2.id
        params[:fund_user_history][:card_id] = @card1.id
        params[:fund_user_history][:buy_or_sell] = true

        expect { post :create, params: params }.to change {
          FundUserHistory.all.length
        }.by(1)
        expect(FundUserHistory.order(:id).last.account_id).to eq @card1
             .account_id
        expect(FundUserHistory.order(:id).last.card_id).to eq @card1.id
      end

      it 'account:nil, card:nilで登録される' do
        params[:fund_user_history][:account_or_card] = '2'
        params[:fund_user_history][:account_id] = @account2.id
        params[:fund_user_history][:card_id] = @card1.id
        params[:fund_user_history][:buy_or_sell] = true

        expect { post :create, params: params }.to change {
          FundUserHistory.all.length
        }.by(1)
        expect(FundUserHistory.order(:id).last.account_id).to eq nil
        expect(FundUserHistory.order(:id).last.card_id).to eq nil
      end
    end
  end

  describe 'destroy' do
    it '正しいuserでなくて失敗' do
      uncorrect_user = create(:user)
      uncorrect_user.confirm
      sign_in uncorrect_user
      fund_user_history =
        @fund_user.fund_user_histories.create(
          value: 1000,
          commission: 100,
          account_id: @account1.id,
          card_id: nil,
          date: Date.today.prev_year(1),
          date: Date.today.prev_year(1),
          buy_or_sell: true
        )
      fund_user_history.after_change_action
      expect {
        delete :destroy,
               params: {
                 fund_user_id: @fund_user.id,
                 id: fund_user_history.id
               }
      }.to change { FundUserHistory.all.length }.by(0)
    end
  end

  describe 'update' do
    let(:params) do
      {
        fund_user_history: {
          'date(1i)' => Date.today.year,
          'date(2i)' => Date.today.month,
          'date(3i)' => Date.today.day,
          'buy_date(1i)' => Date.today.year,
          'buy_date(2i)' => Date.today.month,
          'buy_date(3i)' => Date.today.day,
          :value => 2000,
          :commission => 200,
          :buy_or_sell => true,
          :account_or_card => '0',
          :account_id => @account2.id,
          :card_id => @card1.id
        },
        fund_user_id: @fund_user.id
      }
    end
    describe 'updateに失敗' do
      it 'valueがなくて失敗するがaccount, cardに変化がない' do
        fund_user_history =
          @fund_user.fund_user_histories.create(
            value: 1000,
            commission: 100,
            account_id: @card1.account_id,
            card_id: @card1.id,
            date: Date.today,
            buy_or_sell: true
          )
        fund_user_history.after_change_action
        params[:id] = fund_user_history.id
        params[:fund_user_history][:value] = ''
        expect { put :update, params: params }.to change {
          FundUserHistory.find(fund_user_history.id).account_id
        }.by(0).and change{FundUserHistory.find(fund_user_history.id).card_id}.by(0)
      end

      it '正しいuserでなくて失敗' do
        uncorrect_user = create(:user)
        uncorrect_user.confirm
        sign_in uncorrect_user
        fund_user_history =
          @fund_user.fund_user_histories.create(
            value: 1000,
            commission: 100,
            account_id: @card1.account_id,
            card_id: @card1.id,
            date: Date.today,
            buy_or_sell: true
          )
        fund_user_history.after_change_action
        params[:id] = fund_user_history.id
        params[:fund_user_history][:value] = '1000'
        expect { put :update, params: params }.to change {
          FundUserHistory.find(fund_user_history.id).account_id
        }.by(0).and change{FundUserHistory.find(fund_user_history.id).card_id}.by(0)
      end
    end
  end
end
