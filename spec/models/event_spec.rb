# == Schema Information
#
# Table name: events
#
#  id         :bigint           not null, primary key
#  date       :date
#  iae        :boolean          default(FALSE)
#  memo       :string(255)
#  pay_date   :date
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
    # @user.confirm
    @genre_ex = @user.genres.create(name: 'genre_ex', iae: false)
    @genre_in = @user.genres.create(name: 'genre_in', iae: true)
    @account1 = @user.accounts.create(name: 'account1', value: 1000)
    @card1 =
      @user.cards.create(
        name: 'card1',
        pay_date: 10,
        month_date: 20,
        account_id: @account1.id
      )
  end

  describe 'optional validation' do
    describe 'iae_equal_to_genre' do
      it 'iae:true, genre:false' do
        new_event =
          @user.events.build(
            iae: true,
            value: 100,
            account_id: @account1.id,
            card_id: nil,
            genre_id: @genre_ex.id,
            date: Date.today,
            memo: '',
            pay_date: nil
          )
        expect(new_event).to be_invalid
      end

      it 'iae:false, genre:true' do
        new_event =
          @user.events.build(
            iae: false,
            value: 100,
            account_id: @account1.id,
            card_id: nil,
            genre_id: @genre_in.id,
            date: Date.today,
            memo: '',
            pay_date: nil
          )
        expect(new_event).to be_invalid
      end
    end
    
    it '別のuserのdataを使用してeventを作成できない' do
      different_user = create(:user)
      # different_user.confirm
      new_event =
        different_user.events.build(
          iae: false,
          value: 100,
          account_id: @account1.id,
          card_id: nil,
          genre_id: @genre_in.id,
          date: Date.today,
          memo: '',
          pay_date: nil
        )
      expect(new_event).to be_invalid
    end
  end

  describe 'with controller' do
    describe '#after_change_action' do
      it 'card_id:nilの時' do
        event =
          @user.events.create(
            value: 100,
            card_id: nil,
            account_id: @account1.id,
            genre_id: @genre_in.id,
            date: Date.today,
            iae: true
          )
        event.after_change_action
        expect(event.account_id).to eq @account1.id
        expect(event.card_id).to eq nil
        expect(event.pay_date).to eq nil
      end

      it 'card_id:not_nil,pay_date:nil,date:todayの時' do
        event =
          @user.events.create(
            value: 100,
            account_id: @card1.account_id,
            card_id: @card1.id,
            genre_id: @genre_ex.id,
            date: Date.today,
            iae: false
          )
        event.after_change_action
        expect(event.card_id).to eq @card1.id
        expect(event.account_id).to eq @card1.account_id
        expect(event.pay_date).to eq event.decide_pay_day
      end

      it 'card_id:not_nil,pay_date:nil,date:1year_agoの時' do
        event =
          @user.events.create(
            value: 100,
            account_id: @card1.account_id,
            card_id: @card1.id,
            genre_id: @genre_ex.id,
            date: Date.today.prev_year,
            iae: false
          )
        event.after_change_action
        expect(event.card_id).to eq @card1.id
        expect(event.account_id).to eq @card1.account_id
        expect(event.pay_date).to eq event.decide_pay_day
      end

      it 'card_id:not_nil,pay_date:last_monthの時' do
        event =
          @user.events.create(
            value: 100,
            account_id: @card1.account_id,
            card_id: @card1.id,
            genre_id: @genre_ex.id,
            iae: false,
            date: Date.today.prev_year,
            pay_date: Date.today.prev_month.change(day: @card1.pay_date)
          )
        event.after_change_action
        expect(event.card_id).to eq @card1.id
        expect(event.account_id).to eq @card1.account_id
        expect(event.pay_date).to eq Date.today.prev_month.change(
             day: @card1.pay_date
           )
      end

      it 'card_id:not_nil,pay_date:next_monthの時' do
        event =
          @user.events.create(
            value: 100,
            account_id: @card1.account_id,
            card_id: @card1.id,
            genre_id: @genre_ex.id,
            date: Date.today.prev_year,
            iae: false,
            pay_date: Date.today.next_month.change(day: @card1.pay_date)
          )
        event.after_change_action
        expect(event.card_id).to eq @card1.id
        expect(event.account_id).to eq @card1.account_id
        expect(event.pay_date).to eq Date.today.next_month.change(
             day: @card1.pay_date
           )
      end
    end
  end
end
