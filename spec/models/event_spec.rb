# == Schema Information
#
# Table name: events
#
#  id         :bigint           not null, primary key
#  date       :date
#  iae        :boolean          default(FALSE)
#  memo       :string(255)
#  pay_date   :date
#  pon        :boolean          default(FALSE)
#  value      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  account_id :bigint
#  card_id    :bigint
#  genre_id   :bigint
#  user_id    :bigint           not null
#
# Indexes
#
#  index_events_on_account_id  (account_id)
#  index_events_on_card_id     (card_id)
#  index_events_on_genre_id    (genre_id)
#  index_events_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
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
      account_id: @card1.account.id,
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
      account_id: @card1.account.id,
      date: Date.today,
      pon: true,
    )
    @event1.update(pay_date: @event1.decide_pay_day)
  end

  it "change_ponでfalseからtrueに変化する" do
    expect{
      @event.change_pon
    }.to change{
      Account.find(@card1.account.id).now_value
    }.by(-100)
    expect(Event.find(@event.id).pon).to eq true
  end

  it "change_ponでtrueからfalseに変化する" do
    expect{
      @event1.change_pon
    }.to change{
      Account.find(@card1.account.id).now_value
    }.by(100)
    expect(Event.find(@event1.id).pon).to eq false
  end
end
