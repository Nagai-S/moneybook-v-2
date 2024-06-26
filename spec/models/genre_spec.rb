# == Schema Information
#
# Table name: genres
#
#  id         :bigint           not null, primary key
#  iae        :boolean          default(FALSE)
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_genres_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Genre do
  before do
    @user = create(:user)
    # @user.confirm
    @account1 = @user.accounts.create(name: 'account1', value: 10_000)
    @genre_ex = @user.genres.create(iae: false, name: 'genre_ex')
    @genre_in = @user.genres.create(iae: true, name: 'genre_in')
    @event1 =
      @user.events.create(
        iae: false,
        date: Date.today,
        account_id: @account1.id,
        card_id: nil,
        genre_id: @genre_ex.id,
        value: 100,
        memo: ''
      )
    @event1.after_change_action
    @event2 =
      @user.events.create(
        iae: true,
        date: Date.today.prev_month(2),
        account_id: @account1.id,
        card_id: nil,
        genre_id: @genre_in.id,
        value: 200,
        memo: ''
      )
    @event2.after_change_action
  end

  it '#before_destroy_action' do
    @genre_ex.before_destroy_action
    expect(Event.find(@event1.id).genre_id).to eq nil
    expect(Event.find(@event2.id).genre_id).to eq @genre_in.id
  end
end
