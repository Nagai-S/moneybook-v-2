require 'rails_helper'

RSpec.describe CardsController do
  before do
    @user = create(:user)
    @user.confirm
    sign_in @user
    @genre_ex = @user.genres.create(name: "genre_ex", iae: false)
    @account1 = @user.accounts.create(name: "account1", value: 1000)
    @account2 = @user.accounts.create(name: "account2", value: 1000)
    @card1 = @user.cards.create(
      name: "card1", 
      pay_date: 1, 
      month_date: 20, 
      account_id: @account1.id
    )
  end

  describe "update" do
    describe "編集に成功" do
      it "編集して、ponがfalseからfalseでeventのpay_dateが変わる" do
        today = Date.today
        two_months_later = Date.today.next_month(2)
        event = @user.events.create(
          iae: false,
          memo: "",
          value: 100,
          genre_id: @genre_ex.id,
          card_id: @card1.id,
          date: Date.new(today.year,today.month,27),
          pon: false
        )
        event.update(pay_date: event.decide_pay_day)
  
        params = {
          card: {
            name: @card1.name,
            pay_date: 11,
            month_date: 20,
            account: @card1.account.id
          },
          id: @card1.id
        }
  
        expect{put :update, params: params}.to change{
          Account.find(@account1.id).value
        }.by(0).and change{
          Account.find(@account1.id).after_pay_value
        }.by(0).and change{
          Event.find(event.id).pay_date
        }.from(
          Date.new(two_months_later.year,two_months_later.month,1)
        ).to(
          Date.new(two_months_later.year,two_months_later.month,11)
        )
        expect(Event.find(event.id).pon).to eq false
      end
  
      it "編集して、ponがtrueからtrue" do
        event = @user.events.create(
          iae: false,
          memo: "",
          value: 100,
          genre_id: @genre_ex.id,
          card_id: @card1.id,
          date: Date.today.prev_year,
          pon: true
        )
        event.update(pay_date: event.decide_pay_day)
  
        params = {
          card: {
            name: @card1.name,
            pay_date: 11,
            month_date: 20,
            account: @card1.account.id
          },
          id: @card1.id
        }
  
        expect{put :update, params: params}.to change{
          Account.find(@account1.id).value
        }.by(0)
        expect(Event.find(event.id).pon).to eq true
      end
  
      it "編集して、ponがfalseからtrue" do
        event = @user.events.create(
          iae: false,
          memo: "",
          value: 100,
          genre_id: @genre_ex.id,
          card_id: @card1.id,
          date: Date.today.prev_year,
          pon: false
        )
        event.update(pay_date: event.decide_pay_day)
  
        params = {
          card: {
            name: @card1.name,
            pay_date: 11,
            month_date: 20,
            account: @card1.account.id
          },
          id: @card1.id
        }
  
        expect{put :update, params: params}.to change{
          Account.find(@account1.id).value
        }.by(-100)
        expect(Event.find(event.id).pon).to eq true
      end
  
      it "編集して、ponがtrueからfalse" do
        ax = @user.account_exchanges.create(
          value: 100,
          card_id: @card1.id,
          to_id: @account2.id,
          date: Date.today,
          pon: true
        )
        ax.update(pay_date: ax.decide_pay_day)
  
        params = {
          card: {
            name: @card1.name,
            pay_date: 31,
            month_date: 20,
            account: @card1.account.id
          },
          id: @card1.id
        }
  
        expect{put :update, params: params}.to change{
          Account.find(@account1.id).value
        }.by(100).and change{
          Account.find(@account2.id).value
        }.by(0)
        expect(AccountExchange.find(ax.id).pon).to eq false
      end
    end
    
    describe "編集に失敗" do
      it "userが正しくなくて失敗" do
        uncorrect_user = create(:user)
        uncorrect_user.confirm
        sign_in uncorrect_user
        a_month_before = Date.today.prev_month
        event = @user.events.create(
          iae: false,
          memo: "",
          value: 100,
          genre_id: @genre_ex.id,
          card_id: @card1.id,
          date: Date.today,
          pon: true
        )
        event.update(pay_date: event.decide_pay_day)
  
        params = {
          card: {
            name: @card1.name,
            pay_date: 31,
            month_date: 20,
            account: @card1.account.id
          },
          id: @card1.id
        }
  
        expect{put :update, params: params}.to change{
          Account.find(@account1.id).value
        }.by(0).and change{
          @card1.pay_date
        }.by(0).and change{
          @card1.month_date
        }.by(0)
        expect(Event.find(event.id).pon).to eq true
      end
    end
  end

  describe "destroy" do
    let(:params) {{id: @card1.id}} 
    describe "destroy成功" do
      it "イベントと振替のcard_idがnilになる" do
        event = @user.events.create(
          iae: false,
          memo: "",
          value: 100,
          genre_id: @genre_ex.id,
          card_id: @card1.id,
          date: Date.today.prev_year,
          pon: false
        )
        ax = @user.account_exchanges.create(
          value: 100,
          card_id: @card1.id,
          date: Date.today.prev_year,
          pon: false
        )
        event.update(pay_date: event.decide_pay_day)
        ax.update(pay_date: ax.decide_pay_day)
        event.change_pon(event.pon)
        ax.change_pon(ax.pon)

        expect{delete :destroy, params: params}.to change{
          Card.all.length
        }.by(-1)
        expect(Event.find(event.id).card_id).to eq nil
        expect(AccountExchange.find(ax.id).card_id).to eq nil
      end
    end
    
    describe "destroy失敗" do
      it "未引き落としイベントがあってdestroyできない" do
        event = @user.events.create(
          iae: false,
          memo: "",
          value: 100,
          genre_id: @genre_ex.id,
          card_id: @card1.id,
          date: Date.today,
          pon: false
        )
        event.update(pay_date: event.decide_pay_day)
  
        expect{delete :destroy, params: params}.to change{
          Card.all.length
        }.by(0)
        expect(Event.find(event.id).card_id).to eq @card1.id
      end
  
      it "未引き落とし振り替えがあってdestroyできない" do
        ax = @user.account_exchanges.create(
          value: 100,
          card_id: @card1.id,
          date: Date.today,
          pon: false
        )
        ax.update(pay_date: ax.decide_pay_day)
  
        expect{delete :destroy, params: params}.to change{
          Card.all.length
        }.by(0)
        expect(AccountExchange.find(ax.id).card_id).to eq @card1.id
      end
  
      it "正しくないuserでdestroyできない" do
        uncorrect_user = create(:user)
        uncorrect_user.confirm
        sign_in uncorrect_user
        ax = @user.account_exchanges.create(
          value: 100,
          card_id: @card1.id,
          date: Date.today.prev_year,
          pon: false
        )
        ax.update(pay_date: ax.decide_pay_day)
        ax.change_pon(ax.pon)
  
        expect{delete :destroy, params: params}.to change{
          Card.all.length
        }.by(0)
        expect(AccountExchange.find(ax.id).card_id).to eq @card1.id
      end
    end
  end
  
  
end