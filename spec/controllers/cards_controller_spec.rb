require 'rails_helper'

RSpec.describe CardsController do
  before do
    @user=create(:user)
    @user.confirm
    sign_in @user
    @genre_ex=@user.genres.create(name: "genre_ex", iae: false)
    @account1=@user.accounts.create(name: "account1", value: 1000)
    @card1=@user.cards.create(
      name: "card1", 
      pay_date: 1, 
      month_date: 20, 
      account_id: @account1.id
    )
  end

  describe "update" do
    it "編集して、ponがfalseからfalseでeventのpay_dateが変わる" do
      today=Date.today
      two_months_later=Date.today.next_month(2)
      event=@user.events.create(
        iae: false,
        memo: "",
        value: 100,
        genre_id: @genre_ex.id,
        card_id: @card1.id,
        date: Date.new(today.year,today.month,27),
        pon: false
      )
      event.update(pay_date: event.decide_pay_day)

      params={
        user_id: @user.id,
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
        Event.find(event.id).pay_date
      }.from(
        Date.new(two_months_later.year,two_months_later.month,1)
      ).to(
        Date.new(two_months_later.year,two_months_later.month,11)
      )
      expect(Event.find(event.id).pon).to eq false
    end

    it "編集して、ponがtrueからtrue" do
      event=@user.events.create(
        iae: false,
        memo: "",
        value: 100,
        genre_id: @genre_ex.id,
        card_id: @card1.id,
        date: Date.today.prev_year,
        pon: true
      )
      event.update(pay_date: event.decide_pay_day)

      params={
        user_id: @user.id,
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
      today=Date.today
      event=@user.events.create(
        iae: false,
        memo: "",
        value: 100,
        genre_id: @genre_ex.id,
        card_id: @card1.id,
        date: Date.today.prev_year,
        pon: false
      )
      event.update(pay_date: event.decide_pay_day)

      params={
        user_id: @user.id,
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
      a_month_before=Date.today.prev_month
      event=@user.events.create(
        iae: false,
        memo: "",
        value: 100,
        genre_id: @genre_ex.id,
        card_id: @card1.id,
        date: Date.today,
        pon: true
      )
      event.update(pay_date: event.decide_pay_day)

      params={
        user_id: @user.id,
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
      }.by(100)
      expect(Event.find(event.id).pon).to eq false
    end
  end
  
end