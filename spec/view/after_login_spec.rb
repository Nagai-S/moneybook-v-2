require 'rails_helper'

RSpec.feature 'AfterLoginView', type: :feature do
  before do
    @user = create(:user)
    @user.confirm
    visit new_user_session_path
    fill_in 'user[email]', with: @user.email
    fill_in 'user[password]', with: @user.password
    click_button 'ログイン'
  end

  describe 'サインアップ直後の表示のテスト' do
    it 'root_path' do
      visit root_path
      expect(page).to have_content 'All rights reserved by S.N.'
    end
    it 'funds_index_path' do
      visit funds_index_path
      expect(page).to have_content 'All rights reserved by S.N.'
    end
    it 'funds_search_path' do
      visit funds_search_path
      expect(page).to have_content 'All rights reserved by S.N.'
    end
    it 'accounts_path' do
      visit accounts_path
      expect(page).to have_content 'All rights reserved by S.N.'
    end
    it 'new_account_path' do
      visit new_account_path
      expect(page).to have_content 'All rights reserved by S.N.'
    end
    it 'genres_path' do
      visit genres_path
      expect(page).to have_content 'All rights reserved by S.N.'
    end
    it 'new_genre_path' do
      visit new_genre_path
      expect(page).to have_content 'All rights reserved by S.N.'
    end
    it 'cards_path' do
      visit cards_path
      expect(page).to have_content 'All rights reserved by S.N.'
    end
    it 'new_card_path' do
      visit new_card_path
      expect(page).to have_content 'All rights reserved by S.N.'
    end
    it 'events_path' do
      visit events_path
      expect(page).to have_content 'All rights reserved by S.N.'
    end
    it 'new_event_path' do
      visit new_event_path
      expect(page).to have_content 'All rights reserved by S.N.'
    end
    it 'account_exchanges_path' do
      visit account_exchanges_path
      expect(page).to have_content 'All rights reserved by S.N.'
    end
    it 'new_account_exchange_path' do
      visit new_account_exchange_path
      expect(page).to have_content 'All rights reserved by S.N.'
    end
    it 'new_shortcut_path' do
      visit new_shortcut_path
      expect(page).to have_content 'All rights reserved by S.N.'
    end
    it 'fund_users_path' do
      visit fund_users_path
      expect(page).to have_content 'All rights reserved by S.N.'
    end
    it 'account_month_path' do
      visit account_month_path
      expect(page).to have_content 'All rights reserved by S.N.'
    end
    it 'explanation_path' do
      visit explanation_path
      expect(page).to have_content 'All rights reserved by S.N.'
    end
    it 'events_search_path' do
      visit events_search_path
      expect(page).to have_content 'All rights reserved by S.N.'
    end
  end
end
