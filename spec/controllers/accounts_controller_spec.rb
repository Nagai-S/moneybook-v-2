require 'rails_helper'

RSpec.describe AccountsController do
  before do
    @user = create(:user)
    @user.confirm
    sign_in @user
    @genre_ex = @user.genres.create(name: "genre_ex", iae: false)
    @account1 = @user.accounts.create(name: "account1", value: 1000)
    @account2 = @user.accounts.create(name: "account2", value: 1000)
  end

  describe "destroy" do
    let(:params) { {id: @account1.id} } 
    context "成功" do
      it "eventとaxのaccount_idがnilになる" do
        event = @user.events.create(
          iae: false,
          memo: "",
          value: 100,
          genre_id: @genre_ex.id,
          account_id: @account1.id,
          card_id: nil,
          date: Date.today,
          pon: true
        )
        ax1 = @user.account_exchanges.create(
          value: 100,
          source_id: @account1.id,
          card_id: nil,
          to_id: @account2.id,
          date: Date.today,
          pon: true
        )
        ax2 = @user.account_exchanges.create(
          value: 100,
          source_id: @account2.id,
          card_id: nil,
          to_id: @account1.id,
          date: Date.today,
          pon: true
        )

        expect{delete :destroy, params: params}.to change{
          Account.all.length
        }.by(-1)
        expect(Event.find(event.id).account_id).to eq nil
        expect(AccountExchange.find(ax1.id).source_id).to eq nil
        expect(AccountExchange.find(ax2.id).to_id).to eq nil
      end
      
    end
    context "失敗" do
      it "クレジットカードが存在してdestroyできない" do
        card1 = @user.cards.create(
          name: "card1", 
          pay_date: 1, 
          month_date: 20, 
          account_id: @account1.id
        )
        expect{delete :destroy, params: params}.to change{
          Account.all.length
        }.by(0)
      end

      it "正しくないuserでdestroyできない" do
        uncorrect_user = create(:user)
        uncorrect_user.confirm
        sign_in uncorrect_user
        expect{delete :destroy, params: params}.to change{
          Account.all.length
        }.by(0)
      end
    end
  end
  
end