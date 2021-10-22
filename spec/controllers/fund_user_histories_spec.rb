require 'rails_helper'

RSpec.describe FundUserHistoriesController do
  before do
    @user = create(:user)
    @user.confirm
    sign_in @user

    @account = @user.accounts.create(
      value: 10000,
      name: "account1"
    )
    @account2 = @user.accounts.create(
      value: 20000,
      name: "account2"
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

    @fund = Fund.create(
      name: "fund1",
      value: 10000,
    )
    @fund_user = @user.fund_users.create(
      average_buy_value: 9000,
      fund_id: @fund.id
    )
  end

  describe "create" do
    let(:params) { 
      {
        fund_user_history: {
          "date(1i)" => Date.today.year,
          "date(2i)" => Date.today.month,
          "date(3i)" => Date.today.day,
          value: 1000,
          commission: 100,
          buy_or_sell: true,
          account_or_card: "0",
          account: @account.id,
          card: @card.id,
        },
        fund_user_id: @fund_user.id
      }
     } 
    context "成功" do
      context "購入" do
        it "accountとcardがともにnilでcreate" do
          params[:fund_user_history][:account_or_card] = "2"
          expect{post :create, params: params}.to change{
            FundUserHistory.all.length
          }.by(1).and change{
            Account.find(@account.id).now_value
          }.by(0).and change{
            Card.find(@card.id).account.now_value
          }.by(0)
        end

        it "accountで購入してaccountからvalue分引かれる" do
          params[:fund_user_history][:account_or_card] = "0"
          expect{post :create, params: params}.to change{
            FundUserHistory.all.length
          }.by(1).and change{
            Account.find(@account.id).now_value
          }.by(-1000).and change{
            Card.find(@card.id).account.now_value
          }.by(0)
        end
        
        it "cardで未払いの状態で購入してcard.accountに変化がない" do
          params[:fund_user_history][:account_or_card] = "1"
          expect{post :create, params: params}.to change{
            FundUserHistory.all.length
          }.by(1).and change{
            Account.find(@account.id).now_value
          }.by(0).and change{
            Card.find(@card.id).account.now_value
          }.by(0).and change{
            Card.find(@card.id).account.after_pay_value
          }.by(-1000)
        end
        
        it "cardで支払い済みの状態で購入してcard.accountからvalue分引かれる" do
          params[:fund_user_history][:account_or_card] = "1"
          params[:fund_user_history]["date(1i)"] = Date.today.prev_year.year
          expect{post :create, params: params}.to change{
            FundUserHistory.all.length
          }.by(1).and change{
            Account.find(@account.id).now_value
          }.by(0).and change{
            Card.find(@card.id).account.now_value
          }.by(-1000)
        end
      end
      
      context "売却" do
        it "accountにvalue-commissionの分増える" do
          params[:fund_user_history][:buy_or_sell] = false
          params[:fund_user_history][:account_or_card] = "0"
          expect{post :create, params: params}.to change{
            FundUserHistory.all.length
          }.by(1).and change{
            Account.find(@account.id).now_value
          }.by(900).and change{
            Card.find(@card.id).account.now_value
          }.by(0)
        end
      end
    end

    context "失敗" do
      it "valueがなくて失敗" do
        params[:fund_user_history][:account_or_card] = "0"
        params[:fund_user_history][:value] = ""
        expect{post :create, params: params}.to change{
          FundUserHistory.all.length
        }.by(0).and change{
          Account.find(@account.id).now_value
        }.by(0).and change{
          Card.find(@card.id).account.now_value
        }.by(0)
      end
    end
    
  end
  describe "destroy" do
    let(:params) { {fund_user_id: @fund_user.id} } 
    context "成功" do
      context "購入" do
        it "accountとcard両方nilの時何も変化せずdestroy" do
          fund_user_history = @fund_user.fund_user_histories.create(
            buy_or_sell: true,
            commission: 100,
            date: Date.today,
            account_id: nil,
            card_id: nil,
            pon: true,
            value: 1000,
          )
          params[:id] = fund_user_history.id
          expect{delete :destroy, params: params}.to change{
            FundUserHistory.all.length
          }.by(-1).and change{
            Account.find(@account.id).now_value
          }.by(0).and change{
            Card.find(@card.id).account.now_value
          }.by(0)
        end
        
        it "対象accountに購入分が戻ってくる" do
          fund_user_history = @fund_user.fund_user_histories.create(
            buy_or_sell: true,
            commission: 100,
            date: Date.today,
            account_id: @account.id,
            card_id: nil,
            pon: true,
            value: 1000,
          )
          params[:id] = fund_user_history.id
          expect{delete :destroy, params: params}.to change{
            FundUserHistory.all.length
          }.by(-1).and change{
            Account.find(@account.id).now_value
          }.by(1000).and change{
            Card.find(@card.id).account.now_value
          }.by(0)
        end
        
        it "引き落とし済みの時cardに紐づく対象アカウントに購入分が戻ってくる" do
          fund_user_history = @fund_user.fund_user_histories.create(
            buy_or_sell: true,
            commission: 100,
            date: Date.today.prev_year,
            account_id: @card.account.id,
            card_id: @card.id,
            pon: false,
            value: 1000,
          )
          fund_user_history.update(pay_date: fund_user_history.decide_pay_day)
          fund_user_history.change_pon
          params[:id] = fund_user_history.id
          expect{delete :destroy, params: params}.to change{
            FundUserHistory.all.length
          }.by(-1).and change{
            Account.find(@account.id).now_value
          }.by(0).and change{
            Card.find(@card.id).account.now_value
          }.by(1000)
        end
        
        it "未引き落としの時account.now_valueに変化はなくaccount.after_pay_valueが購入分増える" do
          fund_user_history = @fund_user.fund_user_histories.create(
            buy_or_sell: true,
            commission: 100,
            date: Date.today,
            account_id: @card.account.id,
            card_id: @card.id,
            pon: false,
            value: 1000,
          )
          fund_user_history.update(pay_date: fund_user_history.decide_pay_day)
          fund_user_history.change_pon
          params[:id] = fund_user_history.id
          expect{delete :destroy, params: params}.to change{
            FundUserHistory.all.length
          }.by(-1).and change{
            Account.find(@account.id).now_value
          }.by(0).and change{
            Card.find(@card.id).account.now_value
          }.by(0).and change{
            Card.find(@card.id).account.after_pay_value
          }.by(1000)
        end
      end

      context "売却" do
        it "value-commissionの分が対象アカウントから引かれる" do
          fund_user_history = @fund_user.fund_user_histories.create(
            buy_or_sell: false,
            commission: 100,
            date: Date.today,
            account_id: @account.id,
            card_id: nil,
            pon: true,
            value: 1000,
          )
          params[:id] = fund_user_history.id
          expect{delete :destroy, params: params}.to change{
            FundUserHistory.all.length
          }.by(-1).and change{
            Account.find(@account.id).now_value
          }.by(-900).and change{
            Card.find(@card.id).account.now_value
          }.by(0)
        end
      end
      
    end

    context "失敗" do
      it "正しくないuserでdestroyできない" do
        uncorrect_user = create(:user)
        uncorrect_user.confirm
        sign_in uncorrect_user
        fund_user_history = @fund_user.fund_user_histories.create(
          buy_or_sell: true,
          commission: 100,
          date: Date.today,
          account_id: @account.id,
          card_id: nil,
          pon: true,
          value: 1000,
        )
        params[:id] = fund_user_history.id
        expect{delete :destroy, params: params}.to change{
          FundUserHistory.all.length
        }.by(0).and change{
          Account.find(@account.id).now_value
        }.by(0).and change{
          Card.find(@card.id).account.now_value
        }.by(0)
      end
    end
  end

  describe "update" do
    let(:params) { 
      {
        fund_user_history: {
          "date(1i)" => Date.today.year,
          "date(2i)" => Date.today.month,
          "date(3i)" => Date.today.day,
          value: 2000,
          commission: 200,
          buy_or_sell: true,
          account_or_card: "0",
          account: @account.id,
          card: @card.id,
        },
        fund_user_id: @fund_user.id
      }
     } 
     context "成功" do
        it "account:nil,card:nilで新しいaccountのみ変化する" do
          fund_user_history = @fund_user.fund_user_histories.create(
            buy_or_sell: true,
            commission: 100,
            date: Date.today,
            account_id: nil,
            card_id: nil,
            pon: true,
            value: 1000,
          )
          params[:id] = fund_user_history.id
          expect{put :update, params: params}.to change{
            FundUserHistory.find(fund_user_history.id).account_id
          }.and change{
            Account.find(@account.id).now_value
          }.by(-2000)
        end

        it "元のaccountにお金が戻ってくる" do
          fund_user_history = @fund_user.fund_user_histories.create(
            buy_or_sell: true,
            commission: 100,
            date: Date.today,
            account_id: @account2.id,
            card_id: nil,
            pon: true,
            value: 1000,
          )
          params[:id] = fund_user_history.id
          expect{put :update, params: params}.to change{
            FundUserHistory.find(fund_user_history.id).account_id
          }.and change{
            Account.find(@account.id).now_value
          }.by(-2000).and change{
            Account.find(@account2.id).now_value
          }.by(1000)
        end

        it "元のcard.accountにお金が戻ってくる" do
          fund_user_history = @fund_user.fund_user_histories.create(
            buy_or_sell: true,
            commission: 100,
            date: Date.today.prev_year,
            account_id: @card.account.id,
            card_id: @card.id,
            pon: true,
            value: 1000,
          )
          fund_user_history.update(pay_date: fund_user_history.decide_pay_day)
          params[:id] = fund_user_history.id
          expect{put :update, params: params}.to change{
            FundUserHistory.find(fund_user_history.id).account_id
          }.and change{
            Account.find(@account.id).now_value
          }.by(-2000).and change{
            Card.find(@card.id).account.now_value
          }.by(1000)
        end
        
        it "元のcard.accountのafter_pay_valueが増える" do
          fund_user_history = @fund_user.fund_user_histories.create(
            buy_or_sell: true,
            commission: 100,
            date: Date.today,
            account_id: @card.account.id,
            card_id: @card.id,
            pon: false,
            value: 1000,
          )
          fund_user_history.update(pay_date: fund_user_history.decide_pay_day)
          params[:id] = fund_user_history.id
          expect{put :update, params: params}.to change{
            FundUserHistory.find(fund_user_history.id).account_id
          }.and change{
            Account.find(@account.id).now_value
          }.by(-2000).and change{
            Card.find(@card.id).account.after_pay_value
          }.by(1000)
        end
        
        it "card支払い済みからpay_dateを指定して未払いへ変更" do
          fund_user_history = @fund_user.fund_user_histories.create(
            buy_or_sell: true,
            commission: 100,
            date: Date.today.prev_month,
            account_id: @card.account.id,
            card_id: @card.id,
            pon: true,
            value: 1000,
          )
          fund_user_history.update(pay_date: fund_user_history.decide_pay_day)
          params[:id] = fund_user_history.id
          params[:fund_user_history][:account_or_card] = "1"
          params[:fund_user_history]["pay_date(1i)"] = Date.today.year
          params[:fund_user_history]["pay_date(2i)"] = Date.today.next_month(1).month
          params[:fund_user_history]["pay_date(3i)"] = @card.pay_date

          expect{put :update, params: params}.to change{
            FundUserHistory.find(fund_user_history.id).account_id
          }.by(0).and change{
            Card.find(@card.id).account.now_value
          }.by(1000).and change{
            Card.find(@card.id).account.after_pay_value
          }.by(-1000)
          expect(FundUserHistory.find(fund_user_history.id).pon).to eq false  
          expect(
            FundUserHistory.find(fund_user_history.id).pay_date
          ).to eq MyFunction::FlexDate.return_date(
            Date.today.year, Date.today.next_month.month, @card.pay_date
          )
        end
     end
     
     context "失敗" do
        it "valueがなくて失敗" do
          fund_user_history = @fund_user.fund_user_histories.create(
            buy_or_sell: true,
            commission: 100,
            date: Date.today,
            account_id: @account2.id,
            card_id: nil,
            pon: true,
            value: 1000,
          )
          params[:fund_user_history][:value] = ""
          params[:id] = fund_user_history.id

          expect{put :update, params: params}.to change{
            FundUserHistory.find(fund_user_history.id)
            .account_id
          }.by(0).and change{
            Account.find(@account.id).now_value
          }.by(0).and change{
            Account.find(@account2.id).now_value
          }.by(0)
        end
        
        it "正しくないuserで失敗" do
          uncorrect_user = create(:user)
          uncorrect_user.confirm
          sign_in uncorrect_user
          fund_user_history = @fund_user.fund_user_histories.create(
            buy_or_sell: true,
            commission: 100,
            date: Date.today,
            account_id: @account2.id,
            card_id: nil,
            pon: true,
            value: 1000,
          )
          params[:id] = fund_user_history.id

          expect{put :update, params: params}.to change{
            FundUserHistory.find(fund_user_history.id)
            .account_id
          }.by(0).and change{
            Account.find(@account.id).now_value
          }.by(0).and change{
            Account.find(@account2.id).now_value
          }.by(0)
        end
     end
  end
  
end