require 'rails_helper'

RSpec.describe Event do
  before do
    @user = create(:user)
    @user.confirm
    @genre_ex = @user.genres.create(name: "genre_ex", iae: false)
    @account1 = @user.accounts.create(name: "account1", value: 1000)
    @card1 = @user.cards.create(
      name: "card1", 
      pay_date: 10, 
      month_date: 20, 
      account_id: @account1.id
    )

    @event = @user.events.create(
      iae: false,
      memo: "",
      value: 100,
      genre_id: @genre_ex.id,
      card_id: @card1.id,
      date: Date.today.prev_year(1),
      pon: false,
    )
    @event.update(pay_date: @event.decide_pay_day)

    @event1 = @user.events.create(
      iae: false,
      memo: "",
      value: 100,
      genre_id: @genre_ex.id,
      card_id: @card1.id,
      date: Date.today,
      pon: true,
    )
    @event1.update(pay_date: @event1.decide_pay_day)
  end

  it "change_ponでfalseからtrueに変化する" do
    expect{
      @event.change_pon(@event.pon)
    }.to change{
      Account.find(@card1.account.id).value
    }.by(-100)
    expect(Event.find(@event.id).pon).to eq true
  end

  it "change_ponでtrueからfalseに変化する" do
    expect{
      @event1.change_pon(@event1.pon)
    }.to change{
      Account.find(@card1.account.id).value
    }.by(100)
    expect(Event.find(@event1.id).pon).to eq false
  end
end