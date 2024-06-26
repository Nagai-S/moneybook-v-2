require 'rails_helper'

RSpec.describe AccountsController do
  before do
    @user = create(:user)
    # @user.confirm
    sign_in @user
    @genre_ex = @user.genres.create(name: 'genre_ex', iae: false)
    @account1 = @user.accounts.create(name: 'account1', value: 1000)
  end

  describe 'destroy' do
    let(:params) { { id: @account1.id } }
    context '失敗' do
      it 'クレジットカードが存在してdestroyできない' do
        card1 =
          @user.cards.create(
            name: 'card1',
            pay_date: 1,
            month_date: 20,
            account_id: @account1.id
          )
        expect { delete :destroy, params: params }.to change {
          Account.all.length
        }.by(0)
      end

      it '正しくないuserでdestroyできない' do
        uncorrect_user = create(:user)
        # uncorrect_user.confirm
        sign_in uncorrect_user
        expect { delete :destroy, params: params }.to change {
          Account.all.length
        }.by(0)
      end
    end
  end
end
