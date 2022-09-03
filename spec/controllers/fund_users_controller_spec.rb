require 'rails_helper'

RSpec.describe FundUsersController do
  before do
    @user = create(:user)
    @user.confirm
    sign_in @user

    @fund =
      Fund.create(
        name: 'fund1',
        value: 10_000,
        update_on: nil,
        string_id: 'JP90C000CVU4'
      )
    @fund_updated =
      Fund.create(
        name: 'fund1',
        value: 10_000,
        update_on: Date.today,
        string_id: 'JP90C0000VZ4'
      )
  end

  describe 'create' do
    let(:params) { { fund_user: { average_buy_value: 9000 } } }
    describe 'total_buy_valueがある' do
      it 'valueとupdate_onが更新される' do
        params[:fund_user][:fund_id] = @fund.id
        params[:fund_user][:total_buy_value] = 20_000
        expect { post :create, params: params }.to change {
          FundUserHistory.all.length
        }.by(1).and change { FundUser.all.length }.by(1).and change {
          Fund.find(@fund.id).update_on
        }.and change { Fund.find(@fund.id).value }
      end

      it 'valueとupdate_onが更新されない' do
        params[:fund_user][:fund_id] = @fund_updated.id
        params[:fund_user][:total_buy_value] = 20_000
        expect { post :create, params: params }.to change {
          FundUserHistory.all.length
        }.by(1).and change { FundUser.all.length }.by(1).and change {
          Fund.find( @fund_updated .id ).update_on
        }.by(0).and change { Fund.find(@fund_updated.id).value }.by(0)
      end
    end

    it 'total_buy_valueがない' do
      params[:fund_user][:fund_id] = @fund_updated.id
      expect { post :create, params: params }.to change {
        FundUserHistory.all.length
      }.by(0).and change { FundUser.all.length }.by(1)
    end

    it 'total_buy_value=0' do
      params[:fund_user][:fund_id] = @fund_updated.id
      params[:fund_user][:total_buy_value] = '0'
      expect { post :create, params: params }.to change {
        FundUserHistory.all.length
      }.by(0).and change { FundUser.all.length }.by(1)
    end
  end

  describe 'destroy' do
    it '正しくないuserでdestroyできない' do
      uncorrect_user = create(:user)
      uncorrect_user.confirm
      sign_in uncorrect_user

      fund_user =
        @user.fund_users.create(average_buy_value: 9000, fund_id: @fund.id)

      expect { delete :destroy, params: { id: fund_user.id } }.to change {
        FundUser.all.length
      }.by(0)
    end
  end
end
