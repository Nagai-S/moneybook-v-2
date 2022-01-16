require 'rails_helper'

RSpec.describe AccountExchangesController do
  before do
    @user = create(:user)
    @user.confirm
    sign_in @user

    @account1 = @user.accounts.create(name: 'account1', value: 1000)
    @account2 = @user.accounts.create(name: 'account2', value: 2000)
    @account3 = @user.accounts.create(name: 'account3', value: 3000)
    @card1 =
      @user.cards.create(
        name: 'card1',
        pay_date: 10,
        month_date: 20,
        account_id: @account3.id
      )
    @card2 =
      @user.cards.create(
        name: 'card2',
        pay_date: 20,
        month_date: 10,
        account_id: @account2.id
      )
  end

  describe 'create' do
    let(:params) do
      {
        account_exchange: {
          'date(1i)' => Date.today.year,
          'date(2i)' => Date.today.month,
          'date(3i)' => Date.today.day,
          :value => 100,
          :to_id => @account1.id
        }
      }
    end
    describe 'association_model_update' do
      it '正しいsource, toで登録される' do
        params[:account_exchange][:account_or_card] = '0'
        params[:account_exchange][:source_id] = @account2.id
        params[:account_exchange][:card_id] = @card1.id

        expect { post :create, params: params }.to change {
          AccountExchange.all.length
        }.by(1)
        expect(AccountExchange.order(:id).last.to_id).to eq @account1.id
        expect(AccountExchange.order(:id).last.source_id).to eq @account2.id
        expect(AccountExchange.order(:id).last.card_id).to eq nil
      end

      it '正しいcard, toで登録される' do
        params[:account_exchange][:account_or_card] = '1'
        params[:account_exchange][:source_id] = @account2.id
        params[:account_exchange][:card_id] = @card1.id

        expect { post :create, params: params }.to change {
          AccountExchange.all.length
        }.by(1)
        expect(AccountExchange.order(:id).last.to_id).to eq @account1.id
        expect(AccountExchange.order(:id).last.source_id).to eq @card1.account
             .id
        expect(AccountExchange.order(:id).last.card_id).to eq @card1.id
      end
    end
  end

  describe 'destroy' do
    it '正しいuserでなくて失敗' do
      uncorrect_user = create(:user)
      uncorrect_user.confirm
      sign_in uncorrect_user
      ax =
        @user.account_exchanges.create(
          value: 100,
          source_id: @account1.id,
          card_id: nil,
          date: Date.today.prev_year(1),
          to_id: @account2.id,
          pon: true
        )
      expect { delete :destroy, params: { id: ax.id } }.to change {
        AccountExchange.all.length
      }.by(0)
    end
  end

  describe 'update' do
    let(:params) do
      {
        account_exchange: {
          'date(1i)': Date.today.year,
          'date(2i)': Date.today.month,
          'date(3i)': Date.today.day,
          account_or_card: '0',
          source_id: @account2.id,
          card_id: @card1.id,
          to_id: @account3.id
        }
      }
    end
    describe 'updateに失敗' do
      it 'valueがなくて失敗するがsource_accountやto_account、cardに変化がない' do
        ax =
          @user.account_exchanges.create(
            value: 100,
            source_id: @account1.id,
            card_id: nil,
            date: Date.today,
            to_id: @account2.id,
            pon: true
          )
        params[:id] = ax.id
        params[:account_exchange][:value] = ''
        expect { put :update, params: params }.to change {
          AccountExchange.find(ax.id).to_id
        }.by(0).and change { AccountExchange.find(ax.id).source_id }.by(0)
      end

      it '正しいuserでなくて失敗' do
        uncorrect_user = create(:user)
        uncorrect_user.confirm
        sign_in uncorrect_user
        ax =
          @user.account_exchanges.create(
            value: 100,
            source_id: @account3.id,
            card_id: nil,
            date: Date.today,
            to_id: @account2.id,
            pon: true
          )
        params[:id] = ax.id
        params[:account_exchange][:value] = '100'
        expect { put :update, params: params }.to change {
          AccountExchange.find(ax.id).source_id
        }.by(0).and change { AccountExchange.find(ax.id).to_id }.by(0)
      end
    end
  end
end
