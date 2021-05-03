require 'rails_helper'

RSpec.describe EventsController do
  before do
    @user=create(:user)
    @user.confirm
    sign_in @user
    @genre_ex=@user.genres.create(name: "genre_ex", iae: false)
    @genre_in=@user.genres.create(name: "genre_in", iae: true)
    @account1=@user.accounts.create(name: "account1", value: 1000)
    @account2=@user.accounts.create(name: "account2", value: 2000)
    @card1=@user.cards.create(
      name: "card1", 
      pay_date: 10, 
      month_date: 20, 
      account_id: @account1.id
    )
    @card2=@user.cards.create(
      name: "card2", 
      pay_date: 20, 
      month_date: 10, 
      account_id: @account2.id
    )
  end
  
  describe "create" do
    describe "createに成功" do
      it "accountの収入で登録" do
        params={
          user_id: @user.id,
          event:{
            iae: true,
            "date(1i)": "2020",
            "date(2i)": "2",
            "date(3i)": "20",
            genre: @genre_in.id,
            account_or_card: "0",
            account: @account1.id,
            card: @card1.id,
            memo: "",
            value: 100,
          }
        }
        expect{
          post :create, params: params
        }.to change{
          Account.find(@account1.id).value
        }.by(100) 
      end

      it "accountの支出で登録" do
        params={
          user_id: @user.id,
          event:{
            iae: false,
            "date(1i)": "2020",
            "date(2i)": "2",
            "date(3i)": "20",
            genre: @genre_ex.id,
            account_or_card: "0",
            account: @account1.id,
            card: @card1.id,
            memo: "",
            value: 100,
          }
        }
        expect{post :create, params: params}.to change{Account.find(@account1.id).value}.by(-100)
      end

      it "card未払いで登録" do
        params={
          user_id: @user.id,
          event:{
            iae: false,
            "date(1i)": Date.today.year,
            "date(2i)": Date.today.month,
            "date(3i)": Date.today.day,
            genre: @genre_ex.id,
            account_or_card: "1",
            account: @account1.id,
            card: @card1.id,
            memo: "",
            value: 100,
          }
        }
        expect{
          post :create, params: params
        }.to change{
          Account.find(@card1.account.id).value
        }.by(0).and change{
          Account.find(@card1.account.id).after_pay_value
        }.by(-100)
      end

      it "card支払い済みで登録" do
        params={
          user_id: @user.id,
          event:{
            iae: false,
            "date(1i)": Date.today.year-1,
            "date(2i)": Date.today.month,
            "date(3i)": Date.today.day,
            genre: @genre_ex.id,
            account_or_card: "1",
            account: @account1.id,
            card: @card1.id,
            memo: "",
            value: 100,
          }
        }
        expect{post :create, params: params}.to change{Account.find(@card1.account.id).value}.by(-100)
      end
    end
    
    describe "createに失敗" do
      it "accountで失敗" do
        params={
          user_id: @user.id,
          event:{
            iae: false,
            "date(1i)": "2020",
            "date(2i)": "2",
            "date(3i)": "20",
            genre: @genre_ex.id,
            account_or_card: "0",
            account: @account1.id,
            card: @card1.id,
            memo: "",
            value: "",
          }
        }
        expect{post :create, params: params}.to change{Account.find(@account1.id).value}.by(0)
      end
    end
  end

  describe "destroy" do
    it "accountの支出の登録のdestroy" do
      event=@user.events.create(
        iae: false,
        memo: "",
        value: 100,
        genre_id: @genre_ex.id,
        account_id: @account1.id,
        date: Date.today,
        pon: true,
      )
      expect{
        delete :destroy, params: {user_id: @user.id, id: event.id}
      }.to change{Account.find(@account1.id).value}.by(100)  
    end

    it "accountの収入の登録のdestroy" do
      event=@user.events.create(
        iae: true,
        memo: "",
        value: 100,
        genre_id: @genre_in.id,
        account_id: @account1.id,
        date: Date.today,
        pon: true,
      )
      expect{
        delete :destroy, params: {user_id: @user.id, id: event.id}
      }.to change{Account.find(@account1.id).value}.by(-100)  
    end

    it "card未払いの登録のdestroy" do
      event=@user.events.create(
        iae: false,
        memo: "",
        value: 100,
        genre_id: @genre_ex.id,
        card_id: @card1.id,
        date: Date.today,
        pon: false,
      )
      event.update(pay_date: event.decide_pay_day)
      expect{
        delete :destroy, params: {user_id: @user.id, id: event.id}
      }.to change{
        Account.find(@card1.account.id).value
      }.by(0).and change{
        Account.find(@card1.account.id).after_pay_value
      }.by(100)
    end

    it "card支払い済みの登録のdestroy" do
      event=@user.events.create(
        iae: false,
        memo: "",
        value: 100,
        genre_id: @genre_ex.id,
        card_id: @card1.id,
        date: Date.today.prev_year(1),
        pon: true,
      )
      event.update(pay_date: event.decide_pay_day)
      expect{
        delete :destroy, params: {user_id: @user.id, id: event.id}
      }.to change{Account.find(@card1.account.id).value}.by(100) 
    end
  end
  
  describe "update" do
    describe "updateに成功" do
      let(:params) {{
        user_id: @user.id,
        event:{
          iae: false,
          "date(1i)": "2020",
          "date(2i)": "2",
          "date(3i)": "20",
          genre: @genre_ex.id,
          account_or_card: "0",
          account: @account2.id,
          card: @card1.id,
          memo: "",
          value: 200,
        }
      }}

      it "accountの支出から変更" do
        event=@user.events.create(
          iae: false,
          memo: "",
          value: 100,
          genre_id: @genre_ex.id,
          account_id: @account1.id,
          date: Date.today,
          pon: true,
        )
        params[:id]=event.id
        expect{put :update, params: params}.to change{
          Account.find(@account1.id).value
        }.by(100).and change{
          Account.find(@account2.id).value
        }.by(-200)
      end

      it "accountの収入から変更" do
        event=@user.events.create(
          iae: true,
          memo: "",
          value: 100,
          genre_id: @genre_in.id,
          account_id: @account1.id,
          date: Date.today,
          pon: true,
        )
        params[:id]=event.id
        expect{put :update, params: params}.to change{
          Account.find(@account1.id).value
        }.by(-100).and change{
          Account.find(@account2.id).value
        }.by(-200)
      end

      it "card未払いから変更" do
        event=@user.events.create(
          iae: false,
          memo: "",
          value: 100,
          genre_id: @genre_ex.id,
          card_id: @card1.id,
          date: Date.today,
          pon: false,
        )
        event.update(pay_date: event.decide_pay_day)
        params[:id]=event.id
        expect{put :update, params: params}.to change{
          Account.find(@card1.account.id).value
        }.by(0).and change{
          Account.find(@account2.id).value
        }.by(-200).and change{
          Account.find(@card1.account.id).after_pay_value
        }.by(100)
      end

      it "card支払い済みからpay_dateを指定して未払いへ変更" do
        event=@user.events.create(
          iae: false,
          memo: "",
          value: 100,
          genre_id: @genre_ex.id,
          card_id: @card1.id,
          date: Date.today.prev_year(1),
          pon: true,
        )
        event.update(pay_date: event.decide_pay_day)
        params[:id]=event.id
        params[:event][:account_or_card]="1"
        params[:event]["pay_date(1i)"]=Date.today.year
        params[:event]["pay_date(2i)"]=Date.today.next_month(1).month
        params[:event]["pay_date(3i)"]=@card1.pay_date
        expect{put :update, params: params}.to change{
          Account.find(@card1.account.id).value
        }.by(100).and change{
          Account.find(@card1.account.id).after_pay_value
        }.by(-100)
        expect(Event.find(event.id).pon).to eq false
        expect(Event.find(event.id).pay_date).to eq MyFunction::FlexDate.return_date(
          Date.today.year, Date.today.next_month.month, @card1.pay_date
        )
      end

      it "card支払い済みから変更" do
        event=@user.events.create(
          iae: false,
          memo: "",
          value: 100,
          genre_id: @genre_ex.id,
          card_id: @card1.id,
          date: Date.today.prev_year(1),
          pon: true,
        )
        event.update(pay_date: event.decide_pay_day)
        params[:id]=event.id
        expect{put :update, params: params}.to change{
          Account.find(@card1.account.id).value
        }.by(100).and change{
          Account.find(@account2.id).value
        }.by(-200)
      end
    end
    
    describe "updateに失敗" do
      let(:params) {{
        user_id: @user.id,
        event:{
          iae: false,
          "date(1i)": "2020",
          "date(2i)": "2",
          "date(3i)": "20",
          genre: @genre_ex.id,
          account_or_card: "0",
          account: @account2.id,
          card: @card2.id,
          memo: "",
          value: "",
        }
      }}
      it "accountの支出から失敗" do
        event=@user.events.create(
          iae: false,
          memo: "",
          value: 100,
          genre_id: @genre_ex.id,
          account_id: @account1.id,
          date: Date.today,
          pon: true,
        )
        params[:id]=event.id
        expect{put :update, params: params}.to change{
          Account.find(@account1.id).value
        }.by(0).and change{
          Account.find(@account2.id).value
        }.by(0)
      end
    end
  end
  
end