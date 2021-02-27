require 'rails_helper'

RSpec.describe Event do
  before do
    @user=create(:user)
    @user.confirm
    @genre_ex=@user.genres.build(name: "genre_ex", iae: false)
    @genre_ex.save
    @account1=@user.accounts.build(name: "account1", value: 1000)
    @account1.save
    @card1=@user.cards.build(
      name: "card1", 
      pay_date: 10, 
      month_date: 20, 
      account_id: @account1.id
    )
    @card1.save

    @event=@user.events.build(
      iae: false,
      memo: "",
      value: 100,
      genre_id: @genre_ex.id,
      card_id: @card1.id,
      date: Date.today.prev_year(1),
      pon: false,
    )
    @event.update(pay_date: @event.decide_pay_day)
    @event.save
  end

  it "change_ponで変化する" do
    expect{
      @event.change_pon
    }.to change{
      Account.find(@card1.account.id).value
    }.by(-100)
    expect(Event.find(@event.id).pon).to eq true
  end
end