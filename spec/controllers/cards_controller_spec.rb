require 'rails_helper'

RSpec.describe CardsController do
  before do
    @user = create(:user)
    @user.confirm
    sign_in @user
    @genre_ex = @user.genres.create(name: "genre_ex", iae: false)
    @account1 = @user.accounts.create(name: "account1", value: 1000)
    @account2 = @user.accounts.create(name: "account2", value: 1000)
    @account3 = @user.accounts.create(name: "account3", value: 1000)
    @card1 = @user.cards.create(
      name: "card1", 
      pay_date: 1, 
      month_date: 20, 
      account_id: @account1.id
    )
    fund = Fund.create(name: "aaa", value: 10000)
    @fund_user = @user.fund_users.create(
      fund_id: fund.id,
      average_buy_value: 12000,
    )
  end

  describe "update" do
    it "userが正しくなくて失敗" do
      uncorrect_user = create(:user)
      uncorrect_user.confirm
      sign_in uncorrect_user

      params = {
        card: {
          name: @card1.name,
          pay_date: 31,
          month_date: 21,
          account: @card1.account.id
        },
        id: @card1.id
      }

      expect{put :update, params: params}.to change{
        Card.find(@card1.id).pay_date
      }.by(0).and change{
        Card.find(@card1.id).month_date
      }.by(0)
    end
  end

  describe "destroy" do
    let(:params) {{id: @card1.id}} 
    
    it "未引き落としイベントがあってdestroyできない" do
      event = @user.events.create(
        iae: false,
        memo: "",
        value: 100,
        genre_id: @genre_ex.id,
        card_id: @card1.id,
        account_id: nil,
        date: Date.today,
      )
      event.after_change_action

      expect{delete :destroy, params: params}.to change{
        Card.all.length
      }.by(0)
    end

    it "未引き落とし振り替えがあってdestroyできない" do
      ax = @user.account_exchanges.create(
        value: 100,
        card_id: @card1.id,
        source_id: nil,
        to_id: @account2.id,
        date: Date.today,
      )
      ax.after_change_action

      expect{delete :destroy, params: params}.to change{
        Card.all.length
      }.by(0)
    end

    it "未引き落とし投資信託購入があってdestroyできない" do
      fuh = @fund_user.fund_user_histories.create(
        buy_or_sell: true,
        value: 1000,
        commission: 100,
        card_id: @card1.id,
        account_id: nil,
        date: Date.today,
      )
      fuh.after_change_action

      expect{delete :destroy, params: params}.to change{
        Card.all.length
      }.by(0)
    end

    it "正しくないuserでdestroyできない" do
      uncorrect_user = create(:user)
      uncorrect_user.confirm
      sign_in uncorrect_user

      expect{delete :destroy, params: params}.to change{
        Card.all.length
      }.by(0)
    end
  end
  
end