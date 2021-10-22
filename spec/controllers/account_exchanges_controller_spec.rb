require 'rails_helper'

RSpec.describe AccountExchangesController do
  before do
    @user = create(:user)
    @user.confirm
    sign_in @user

    @account1 = @user.accounts.create(name: "account1", value: 1000)
    @account2 = @user.accounts.create(name: "account2", value: 2000)
    @account3 = @user.accounts.create(name: "account3", value: 3000)
    @card1 = @user.cards.create(
      name: "card1", 
      pay_date: 10, 
      month_date: 20, 
      account_id: @account3.id
    )
    @card2 = @user.cards.create(
      name: "card2", 
      pay_date: 20, 
      month_date: 10, 
      account_id: @account2.id
    )
  end

  describe "create" do
    describe "createに成功" do
      it "accountから振り替え" do
        params = {
          account_exchange:{
            "date(1i)": "2020",
            "date(2i)": "2",
            "date(3i)": "20",
            account_or_card: "0",
            source_account: @account1.id,
            card: @card1.id,
            to_account: @account2.id,
            value: 100,
          }
        }
        expect{
          post :create, params: params
        }.to change{
          Account.find(@account1.id).now_value
        }.by(-100).and change{
          Account.find(@account2.id).now_value
        }.by(100)
      end
      
      it "card未払いから振り替え" do
        params = {
          account_exchange:{
            "date(1i)": Date.today.year,
            "date(2i)": Date.today.month,
            "date(3i)": Date.today.day,
            account_or_card: "1",
            source_account: @account1.id,
            card: @card1.id,
            to_account: @account2.id,
            value: 100,
          }
        }
        expect{
          post :create, params: params
        }.to change{
          Account.find(@card1.account.id).now_value
        }.by(0).and change{
          Account.find(@account2.id).now_value
        }.by(100).and change{
          Account.find(@card1.account.id).after_pay_value
        }.by(-100)
      end
      
      it "card支払い済みから振り替え" do
        params = {
          account_exchange:{
            "date(1i)": Date.today.year-1,
            "date(2i)": Date.today.month,
            "date(3i)": Date.today.day,
            account_or_card: "1",
            source_account: @account1.id,
            card: @card1.id,
            to_account: @account2.id,
            value: 100,
          }
        }
        expect{
          post :create, params: params
        }.to change{
          Account.find(@card1.account.id).now_value
        }.by(-100).and change{
          Account.find(@account2.id).now_value
        }.by(100)
      end
    end

    describe "createに失敗" do
      it "valueがなくてaccountからの振り替えに失敗" do
        params = {
          account_exchange:{
            "date(1i)": "2020",
            "date(2i)": "2",
            "date(3i)": "20",
            account_or_card: "0",
            source_account: @account1.id,
            card: @card1.id,
            to_account: @account2.id,
            value: "",
          }
        }
        expect{
          post :create, params: params
        }.to change{
          Account.find(@account1.id).now_value
        }.by(0).and change{
          Account.find(@account2.id).now_value
        }.by(0).and change{
          AccountExchange.all.length
        }.by(0)
      end
    end
  end

  describe "destroy" do
    describe "destroyに成功" do
      it "accountからの振り替えをdestroy" do
        ax = @user.account_exchanges.create(
          value: 100,
          source_id: @account1.id,
          card_id: nil,
          date: Date.today,
          to_id: @account2.id,
          pon: true,
        )
        expect{
          delete :destroy, params: {id: ax.id}
        }.to change{
          Account.find(@account1.id).now_value
        }.by(100).and change{
          Account.find(@account2.id).now_value
        }.by(-100)
      end
      
      it "card未払いからの振り替えをdestroy" do
        ax = @user.account_exchanges.create(
          value: 100,
          card_id: @card1.id,
          source_id: @card1.account.id,
          date: Date.today,
          to_id: @account2.id,
          pon: false,
        )
        ax.update(pay_date: ax.decide_pay_day)
        expect{
          delete :destroy, params: {id: ax.id}
        }.to change{
          Account.find(@card1.account.id).now_value
        }.by(0).and change{
          Account.find(@account2.id).now_value
        }.by(-100).and change{
          Account.find(@card1.account.id).after_pay_value
        }.by(100)
      end
      
      it "card支払い済みからの振り替えをdestroy" do
        ax = @user.account_exchanges.create(
          value: 100,
          card_id: @card1.id,
          source_id: @card1.account.id,
          date: Date.today.prev_year(1),
          to_id: @account2.id,
          pon: true,
        )
        ax.update(pay_date: ax.decide_pay_day)
        expect{
          delete :destroy, params: {id: ax.id}
        }.to change{
          Account.find(@card1.account.id).now_value
        }.by(100).and change{
          Account.find(@account2.id).now_value
        }.by(-100)
      end
  
    end

    describe "destroyに失敗" do
      it "parents_deleted(sourceとcardがない)の時にdestroyできない" do
        ax = @user.account_exchanges.create(
          value: 100,
          source_id: nil,
          card_id: nil,
          date: Date.today.prev_year(1),
          to_id: @account2.id,
          pon: true,
        )
        expect{
          delete :destroy, params: {id: ax.id}
        }.to change{
          Account.find(@account2.id).now_value
        }.by(0).and change{
          AccountExchange.all.length
        }.by(0)
      end

      it "parents_deleted(toがない)の時にdestroyできない" do
        ax = @user.account_exchanges.create(
          value: 100,
          source_id: @account1.id,
          card_id: nil,
          date: Date.today.prev_year(1),
          to_id: nil,
          pon: true,
        )
        expect{
          delete :destroy, params: {id: ax.id}
        }.to change{
          Account.find(@account1.id).now_value
        }.by(0).and change{
          AccountExchange.all.length
        }.by(0)
      end

      it "正しいuserでない時にdestroyできない" do
        uncorrect_user = create(:user)
        uncorrect_user.confirm
        sign_in uncorrect_user
        ax = @user.account_exchanges.create(
          value: 100,
          source_id: @account1.id,
          card_id: nil,
          date: Date.today.prev_year(1),
          to_id: @account2.id,
          pon: true,
        )
        expect{
          delete :destroy, params: {id: ax.id}
        }.to change{
          Account.find(@account1.id).now_value
        }.by(0).and change{
          Account.find(@account2.id).now_value
        }.by(0).and change{
          AccountExchange.all.length
        }.by(0)
      end
    end
  end
  
  describe "update" do
    describe "updateに成功" do
      context "振り替え元を変更" do
        let(:params){{
          account_exchange:{
            "date(1i)": "2020",
            "date(2i)": "2",
            "date(3i)": "20",
            account_or_card: "0",
            source_account: @account1.id,
            card: @card1.id,
            to_account: @account2.id,
            value: 200,
          }
        }}

        it "accountの振り替えから変更" do
          ax = @user.account_exchanges.create(
            value: 100,
            source_id: @account3.id,
            card_id: nil,
            date: Date.today,
            to_id: @account2.id,
            pon: true,
          )
          params[:id] = ax.id
          expect{
            put :update, params: params  
          }.to change{
            Account.find(@account3.id).now_value
          }.by(100).and change{
            Account.find(@account1.id).now_value
          }.by(-200).and change{
            Account.find(@account2.id).now_value
          }.by(100)
        end
        
        it "card未払いの振り替えから変更" do
          ax = @user.account_exchanges.create(
            value: 100,
            card_id: @card1.id,
            source_id: @card1.account.id,
            date: Date.today,
            to_id: @account2.id,
            pon: false,
          )
          ax.update(pay_date: ax.decide_pay_day)
          params[:id] = ax.id
          expect{
            put :update, params: params
          }.to change{
            Account.find(@card1.account.id).now_value
          }.by(0).and change{
            Account.find(@account1.id).now_value
          }.by(-200).and change{
            Account.find(@account2.id).now_value
          }.by(100).and change{
            Account.find(@card1.account.id).after_pay_value
          }.by(100)
        end

        it "card支払い済みの振り替えから変更" do
          ax = @user.account_exchanges.create(
            value: 100,
            card_id: @card1.id,
            source_id: @card1.account.id,
            date: Date.today.prev_year(1),
            to_id: @account2.id,
            pon: true,
          )
          ax.update(pay_date: ax.decide_pay_day)
          params[:id] = ax.id
          expect{
            put :update, params: params
          }.to change{
            Account.find(@card1.account.id).now_value
          }.by(100).and change{
            Account.find(@account1.id).now_value
          }.by(-200).and change{
            Account.find(@account2.id).now_value
          }.by(100)
        end
      end
      
      context "振り替え先を変更" do
        let(:params){{
          account_exchange:{
            "date(1i)": "2020",
            "date(2i)": "2",
            "date(3i)": "20",
            account_or_card: "0",
            source_account: @account1.id,
            card: @card1.id,
            to_account: @account2.id,
            value: 200,
          }
        }}

        it "別のaccountに変更" do
          ax = @user.account_exchanges.create(
            value: 100,
            source_id: @account1.id,
            card_id: nil,
            date: Date.today,
            to_id: @account3.id,
            pon: true,
          )
          params[:id] = ax.id
          expect{
            put :update, params: params  
          }.to change{
            Account.find(@account3.id).now_value
          }.by(-100).and change{
            Account.find(@account1.id).now_value
          }.by(-100).and change{
            Account.find(@account2.id).now_value
          }.by(200)
        end
      end
    end
      
    describe "updateに失敗" do
      it "valueがなくて失敗" do
        params = {
          account_exchange:{
            "date(1i)": "2020",
            "date(2i)": "2",
            "date(3i)": "20",
            account_or_card: "0",
            source_account: @account3.id,
            card: @card1.id,
            to_account: @account2.id,
            value: "",
          }
        }
        ax = @user.account_exchanges.create(
          value: 100,
          source_id: @account3.id,
          card_id: nil,
          date: Date.today,
          to_id: @account1.id,
          pon: true,
        )
        params[:id] = ax.id
        expect{
          put :update, params: params  
        }.to change{
          Account.find(@account3.id).now_value
        }.by(0).and change{
          Account.find(@account1.id).now_value
        }.by(0).and change{
          Account.find(@account2.id).now_value
        }.by(0).and change{
          ax.to_account.id
        }.by(0)
      end

      it "parents_deleted(souceとcard)がなくて失敗" do
        params = {
          account_exchange:{
            "date(1i)": "2020",
            "date(2i)": "2",
            "date(3i)": "20",
            account_or_card: "0",
            source_account: @account3.id,
            card: @card1.id,
            to_account: @account2.id,
            value: 200,
          }
        }
        ax = @user.account_exchanges.create(
          value: 100,
          source_id: nil,
          card_id: nil,
          date: Date.today,
          to_id: @account1.id,
          pon: true,
        )
        params[:id] = ax.id
        expect{
          put :update, params: params  
        }.to change{
          Account.find(@account3.id).now_value
        }.by(0).and change{
          Account.find(@account1.id).now_value
        }.by(0).and change{
          ax.to_account.id
        }.by(0)
      end

      it "parents_deleted(to)がなくて失敗" do
        params = {
          account_exchange:{
            "date(1i)": "2020",
            "date(2i)": "2",
            "date(3i)": "20",
            account_or_card: "0",
            source_account: @account3.id,
            card: @card1.id,
            to_account: @account2.id,
            value: 200,
          }
        }
        ax = @user.account_exchanges.create(
          value: 100,
          source_id: @account2.id,
          card_id: nil,
          date: Date.today,
          to_id: nil,
          pon: true,
        )
        params[:id] = ax.id
        expect{
          put :update, params: params  
        }.to change{
          Account.find(@account3.id).now_value
        }.by(0).and change{
          Account.find(@account2.id).now_value
        }.by(0).and change{
          ax.account.id
        }.by(0)
      end

      it "正しいuserでなくて失敗" do
        uncorrect_user = create(:user)
        uncorrect_user.confirm
        sign_in uncorrect_user
        params = {
          account_exchange:{
            "date(1i)": "2020",
            "date(2i)": "2",
            "date(3i)": "20",
            account_or_card: "1",
            source_account: @account3.id,
            card: @card1.id,
            to_account: @account2.id,
            value: 200,
          }
        }
        ax = @user.account_exchanges.create(
          value: 100,
          source_id: @account3.id,
          card_id: nil,
          date: Date.today,
          to_id: @account2.id,
          pon: true,
        )
        params[:id] = ax.id
        expect{
          put :update, params: params  
        }.to change{
          Account.find(@account3.id).now_value
        }.by(0).and change{
          Account.find(@account2.id).now_value
        }.by(0).and change{
          ax.source_id
        }.by(0)
      end
    end
  end
end