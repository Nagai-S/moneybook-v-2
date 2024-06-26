require 'rails_helper'

RSpec.configure { |config| config.use_transactional_fixtures = false }

RSpec.feature 'UserFlow', type: :feature do
  background do
    @fund = Fund.create(name: 'fund1', value: 10_000, update_on: Date.today)
  end

  scenario 'create user' do
    user = create(:user)
    # user.confirm
    expect(User.all.length).to eq 1
  end

  feature 'user flow test', js: true do
    background do
      @user = User.order(:id).first
      visit new_user_session_path
      fill_in 'user[email]', with: @user.email
      fill_in 'user[password]', with: 'password'
      click_button 'ログイン'
    end

    scenario 'create account' do
      visit new_account_path
      expect(page).to have_content '新規アカウント作成'
      fill_in 'account[name]', with: 'account_name'
      fill_in 'account[value]', with: '1000'
      click_button 'アカウント作成'
      sleep 0.5
      expect(@user.accounts.length).to eq 1
    end

    scenario 'explain pageが表示されない' do
      visit events_path
      expect(page).to have_content '履歴'
    end

    scenario 'create card' do
      visit cards_path
      expect(page).to have_content 'クレジットカード一覧'
      click_on 'クレジットカード登録'
      expect(page).to have_content '新規クレジットカード作成'
      fill_in 'card[name]', with: 'card_name'
      select @user.accounts.first.name, from: 'card[account_id]'
      select 27, from: 'card[pay_date]'
      select 31, from: 'card[month_date]'
      click_button 'クレジットカード登録'
      sleep 0.5
      expect(@user.cards.length).to eq 1
    end

    scenario 'create event iae:true' do
      visit new_event_path
      expect(page).to have_content '新規イベント作成'
      click_on '収入'
      within find('#tab_in') do
        select Date.today.year, from: 'event[date(1i)]'
        select "#{Date.today.month + 1}月", from: 'event[date(2i)]'
        select Date.today.day, from: 'event[date(3i)]'
        select @user.genres.where(iae: true).first.name, from: 'event[genre_id]'
        select @user.accounts.first.name, from: 'event[account_id]'
        fill_in 'event[memo]', with: 'memo'
        fill_in 'event[value]', with: 100
        click_button 'イベント登録'
      end
      sleep 0.5
      expect(@user.events.length).to eq 1
      expect(@user.accounts.first.now_value).to eq 1100
    end

    scenario 'create event iae:false using account' do
      visit new_event_path
      click_on '支出'
      within find('#tab_ex') do
        select Date.today.year, from: 'event[date(1i)]'
        select "#{Date.today.month}月", from: 'event[date(2i)]'
        select Date.today.day, from: 'event[date(3i)]'
        select @user.genres.where(iae: false).order(:id).first.name,
               from: 'event[genre_id]'
        click_on 'アカウント'
        select @user.accounts.first.name, from: 'event[account_id]'
        fill_in 'event[memo]', with: 'memo'
        fill_in 'event[value]', with: 200
        click_button 'イベント登録'
      end
      sleep 0.5
      expect(@user.events.length).to eq 2
      expect(@user.accounts.first.now_value).to eq 900
    end

    scenario 'create event iae:false using card' do
      visit new_event_path
      click_on '支出'
      within find('#tab_ex') do
        select Date.today.year, from: 'event[date(1i)]'
        select "#{Date.today.month}月", from: 'event[date(2i)]'
        select Date.today.day, from: 'event[date(3i)]'
        select @user.genres.where(iae: false).order(:id).first.name,
               from: 'event[genre_id]'
        click_on 'クレジットカード'
        select @user.cards.first.name, from: 'event[card_id]'
        fill_in 'event[memo]', with: 'memo'
        fill_in 'event[value]', with: 150
        click_button 'イベント登録'
      end
      sleep 0.5
      expect(@user.events.length).to eq 3
      expect(@user.accounts.first.now_value).to eq 900
      expect(@user.accounts.first.after_pay_value).to eq 750
    end

    scenario 'edit event' do
      visit events_path
      page.all('a', text: '編集')[0].click
      click_on '支出'
      within find('#tab_ex') do
        select Date.today.year, from: 'event[date(1i)]'
        select "#{Date.today.month}月", from: 'event[date(2i)]'
        select Date.today.day + 1, from: 'event[date(3i)]'
        select @user.genres.where(iae: false).first.name, from: 'event[genre_id]'
        click_on 'アカウント'
        select @user.accounts.first.name, from: 'event[account_id]'
        fill_in 'event[memo]', with: 'memo'
        fill_in 'event[value]', with: 300
        click_button 'イベント登録'
      end
      sleep 0.5
      expect(@user.events.length).to eq 3
      expect(@user.accounts.first.now_value).to eq 500
      expect(@user.accounts.first.after_pay_value).to eq 350
    end

    scenario 'destroy event' do
      visit events_path
      page.accept_confirm { page.all('a', text: '削除')[0].click }
      sleep 0.5
      expect(@user.events.length).to eq 2
      expect(@user.accounts.first.now_value).to eq 800
      expect(@user.accounts.first.after_pay_value).to eq 650
    end

    scenario 'create ax account -> account' do
      @user.accounts.create(name: 'account_name2', value: 1000)
      visit new_account_exchange_path
      within find('.form_wrapper') do
        select Date.today.year, from: 'account_exchange[date(1i)]'
        select "#{Date.today.month}月", from: 'account_exchange[date(2i)]'
        select Date.today.day + 1, from: 'account_exchange[date(3i)]'
        click_on 'アカウント'
        select @user.accounts.order(:id).first.name,
               from: 'account_exchange[source_id]'
        select @user.accounts.order(:id).second.name,
               from: 'account_exchange[to_id]'
        fill_in 'account_exchange[value]', with: 100
        click_button '振替を登録'
      end
      sleep 0.5
      expect(@user.account_exchanges.length).to eq 1
      expect(@user.accounts.order(:id).first.now_value).to eq 700
      expect(@user.accounts.order(:id).second.now_value).to eq 1100
    end

    scenario 'create ax card -> account' do
      visit new_account_exchange_path
      within find('.form_wrapper') do
        select Date.today.year, from: 'account_exchange[date(1i)]'
        select "#{Date.today.month}月", from: 'account_exchange[date(2i)]'
        select Date.today.day, from: 'account_exchange[date(3i)]'
        click_on 'クレジットカード'
        select @user.cards.order(:id).first.name, from: 'account_exchange[card_id]'
        select @user.accounts.order(:id).second.name,
               from: 'account_exchange[to_id]'
        fill_in 'account_exchange[value]', with: 200
        click_button '振替を登録'
      end
      sleep 0.5
      expect(@user.account_exchanges.length).to eq 2
      expect(@user.accounts.order(:id).first.now_value).to eq 700
      expect(@user.accounts.order(:id).first.after_pay_value).to eq 350
      expect(@user.accounts.order(:id).second.now_value).to eq 1300
    end

    scenario 'edit ax' do
      visit account_exchanges_path
      page.all('a', text: '編集')[0].click
      within find('.form_wrapper') do
        select Date.today.year, from: 'account_exchange[date(1i)]'
        select "#{Date.today.month}月", from: 'account_exchange[date(2i)]'
        select Date.today.day + 1, from: 'account_exchange[date(3i)]'
        click_on 'アカウント'
        select @user.accounts.order(:id).second.name,
               from: 'account_exchange[source_id]'
        select @user.accounts.order(:id).first.name,
               from: 'account_exchange[to_id]'
        fill_in 'account_exchange[value]', with: 100
        click_button '振替を登録'
      end
      sleep 0.5
      expect(@user.account_exchanges.length).to eq 2
      expect(@user.accounts.order(:id).first.now_value).to eq 900
      expect(@user.accounts.order(:id).first.after_pay_value).to eq 550
      expect(@user.accounts.order(:id).second.now_value).to eq 1100
    end

    scenario 'destroty ax' do
      visit account_exchanges_path
      page.accept_confirm { page.all('a', text: '削除')[0].click }
      sleep 0.5
      expect(@user.account_exchanges.length).to eq 1
      expect(@user.accounts.order(:id).first.now_value).to eq 800
      expect(@user.accounts.order(:id).first.after_pay_value).to eq 450
      expect(@user.accounts.order(:id).second.now_value).to eq 1200
    end

    scenario 'create fund_user' do
      visit fund_users_path
      expect(page).to have_content '投資信託'
      click_on '投資信託追加'
      expect(page).to have_content '投資信託一覧'
      page.all('a', text: '自分の資産に追加')[0].click
      expect(page).to have_content 'fund1を資産に登録する'
      fill_in 'fund_user[total_buy_value]', with: '1000'
      fill_in 'fund_user[average_buy_value]', with: '9000'
      click_on '資産に追加'
      sleep 0.5
      expect(@user.fund_users.length).to eq 1
      expect(@user.fund_users.first.fund_user_histories.length).to eq 1
      expect(@user.fund_users.first.now_value).to eq(
        (1000.to_f * 10_000.to_f / 9000.to_f).round
      )
      expect(page).to have_content '投資信託'
    end

    scenario 'update average_buy_value' do
      visit fund_users_path
      click_link 'fund1'
      expect(page).to have_content '新しい平均取得価額を入力してください。'
      fill_in 'fund_user[average_buy_value]', with: 9500
      click_on '平均取得価額を更新'
      expect(page).to have_content '更新しました。'
      expect(@user.fund_users.first.now_value).to eq(
        (1000.to_f * 10_000.to_f / 9500.to_f).round
      )
    end

    scenario 'create fuh_buy by account with commission' do
      visit fund_users_path
      click_link 'fund1'
      click_on '購入または売却'
      expect(page).to have_content 'fund1'
      within find('#tab_buy') do
        select Date.today.next_day.year, from: 'fund_user_history[date(1i)]'
        select "#{Date.today.next_day.month}月", from: 'fund_user_history[date(2i)]'
        select Date.today.next_day.day, from: 'fund_user_history[date(3i)]'
        click_on 'アカウント'
        select @user.accounts.order(:id).first.name,
               from: 'fund_user_history[account_id]'
        fill_in 'fund_user_history[commission]', with: 10
        fill_in 'fund_user_history[value]', with: 100
        click_button '購入'
      end
      sleep 0.5
      expect(@user.fund_users.first.fund_user_histories.length).to eq 2
      expect(@user.accounts.order(:id).first.now_value).to eq 700
      expect(@user.accounts.order(:id).first.after_pay_value).to eq 350
      expect(@user.fund_users.first.now_value).to eq(
        (1090.to_f * 10_000.to_f / 9500.to_f).round
      )
    end

    scenario 'create fuh_buy by card without commission' do
      visit fund_users_path
      click_link 'fund1'
      click_on '購入または売却'
      expect(page).to have_content 'fund1'
      within find('#tab_buy') do
        select Date.today.year, from: 'fund_user_history[date(1i)]'
        select "#{Date.today.month}月", from: 'fund_user_history[date(2i)]'
        select Date.today.day, from: 'fund_user_history[date(3i)]'
        click_on 'クレジットカード'
        select @user.cards.order(:id).first.name,
               from: 'fund_user_history[card_id]'
        fill_in 'fund_user_history[commission]', with: 0
        fill_in 'fund_user_history[value]', with: 200
        click_button '購入'
      end
      sleep 0.5
      expect(@user.fund_users.first.fund_user_histories.length).to eq 3
      expect(@user.accounts.order(:id).first.now_value).to eq 700
      expect(@user.accounts.order(:id).first.after_pay_value).to eq 150
      expect(@user.fund_users.first.now_value).to eq(
        (1290.to_f * 10_000.to_f / 9500.to_f).round
      )
    end

    scenario 'create fuh_sell with commission' do
      visit fund_users_path
      click_link 'fund1'
      click_on '購入または売却'
      expect(page).to have_content 'fund1'
      find('.nav a.nav-link', text: '売却').click
      within find('#tab_sell') do
        select Date.today.year, from: 'fund_user_history[date(1i)]'
        select "#{Date.today.month}月", from: 'fund_user_history[date(2i)]'
        select Date.today.day, from: 'fund_user_history[date(3i)]'
        select @user.accounts.order(:id).first.name,
               from: 'fund_user_history[account_id]'
        fill_in 'fund_user_history[commission]', with: 50
        fill_in 'fund_user_history[value]', with: 300
        click_button '売却'
      end
      sleep 0.5
      expect(@user.fund_users.first.fund_user_histories.length).to eq 4
      expect(@user.accounts.order(:id).first.now_value).to eq 950
      expect(@user.accounts.order(:id).first.after_pay_value).to eq 400
      expect(@user.fund_users.first.now_value).to eq(
        ((1290.to_f * 10_000.to_f / 9500.to_f) - 300).round
      )
    end

    scenario 'edit fuh' do
      visit fund_users_path
      click_link 'fund1'
      page.all('a', text: '編集')[0].click
      within find('#tab_buy') do
        select Date.today.next_day.year, from: 'fund_user_history[buy_date(1i)]'
        select "#{Date.today.next_day.month}月", from: 'fund_user_history[buy_date(2i)]'
        select Date.today.next_day.day, from: 'fund_user_history[buy_date(3i)]'
        fill_in 'fund_user_history[commission]', with: 0
        click_button '編集'
      end
      sleep 0.5
      expect(@user.fund_users.first.fund_user_histories.length).to eq 4
      expect(@user.fund_users.first.now_value).to eq(
        ((1200.to_f * 10_000.to_f / 9500.to_f) - 300).round
      )
    end

    scenario 'destroy fuh' do
      visit fund_users_path
      click_link 'fund1'
      page.accept_confirm { page.all('a', text: '削除')[0].click }
      sleep 0.5
      expect(@user.fund_users.first.fund_user_histories.length).to eq 3
      expect(@user.fund_users.first.now_value).to eq(
        ((1200.to_f * 10_000.to_f / 9500.to_f) - 300).round
      )
      expect(@user.accounts.order(:id).first.now_value).to eq 1050
      expect(@user.accounts.order(:id).first.after_pay_value).to eq 500
    end

    scenario 'visit  pay_not_forcard' do
      card2 =
        @user.cards.create(
          name: 'card_name2',
          account_id: @user.accounts.order(:id).first.id,
          pay_date: 4,
          month_date: 10
        )
      visit cards_path
      expect(page).to have_content 'クレジットカード一覧'
      click_link '詳細',
                 href: pay_not_for_card_path(@user.cards.order(:id).first.id)
      expect(page).to have_content 'card_name'
      visit cards_path
      click_link '詳細', href: pay_not_for_card_path(card2.id)
      expect(
        page
      ).to have_content 'このクレジットカードを使用した未引き落としイベントはありません'
    end

    scenario 'show card' do
      visit cards_path
      click_link 'card_name', href: card_path(@user.cards.order(:id).first.id)
      expect(page).to have_content '使用履歴'
    end

    scenario 'edit card' do
      visit cards_path
      click_link '編集', href: edit_card_path(@user.cards.order(:id).first.id)
      select @user.accounts.order(:id).second.name, from: 'card[account_id]'
      select 25, from: 'card[pay_date]'
      click_button 'クレジットカード登録'
      sleep 0.5
      expect(@user.accounts.order(:id).first.now_value).to eq 1050
      expect(@user.accounts.order(:id).first.after_pay_value).to eq 1050
      expect(@user.accounts.order(:id).second.now_value).to eq 1200
      expect(@user.accounts.order(:id).second.after_pay_value).to eq 650
      expect(@user.events.where.not(card_id: nil).first.pay_date.day).to eq 25
    end

    scenario 'failed destroy card' do
      visit cards_path
      page.accept_confirm do
        click_link '削除', href: card_path(@user.cards.order(:id).first.id)
      end
      expect(
        page
      ).to have_content 'このカードを使用した未引き落としのものが存在するため削除できません。'
      expect(@user.cards.length).to eq 2
    end

    scenario 'destroy card' do
      visit cards_path
      page.accept_confirm do
        click_link '削除', href: card_path(@user.cards.order(:id).second.id)
      end
      sleep 0.5
      expect(@user.cards.length).to eq 1
    end

    scenario 'create genre' do
      visit genres_path
      click_on 'ジャンル追加'
      select '支出', from: 'genre[iae]'
      fill_in 'genre[name]', with: 'new_genre_name'
      click_button 'ジャンル登録'
      sleep 0.5
      expect(@user.genres.order(:id).last.name).to eq 'new_genre_name'
    end

    scenario 'show genre and update name' do
      visit genres_path
      expect(page).to have_content 'ジャンル一覧'
      click_link(
        @user.genres.where(iae: false).order(:id).first.name,
        href: genre_path(@user.genres.where(iae: false).order(:id).first.id)
      )
      expect(page).to have_content '使用履歴'
      fill_in 'genre[name]', with: 'genre_ex'
      click_button '名前を変更'
      sleep 0.5
      expect(@user.events.first.genre.name).to eq 'genre_ex'
    end

    scenario 'destroy genre' do
      visit genres_path
      page.accept_confirm do
        click_link '削除',
                   href:
                     genre_path(
                       @user.genres.where(iae: false).order(:id).first.id
                     )
      end
      sleep 0.5
      expect(@user.events.first.genre).to eq nil
    end

    scenario 'failed destroy account' do
      visit accounts_path
      expect(page).to have_content '資産情報'
      page.accept_confirm do
        click_link '削除',
                   href: account_path(@user.accounts.order(:id).second.id)
      end
      expect(
        page
      ).to have_content 'このアカウントに連携したクレジットカードが存在するため削除できません'
      expect(@user.accounts.length).to eq 2
    end

    scenario 'destroy account' do
      visit accounts_path
      expect(page).to have_content '資産情報'
      page.accept_confirm do
        click_link '削除',
                   href: account_path(@user.accounts.order(:id).first.id)
      end
      sleep 0.5
      expect(@user.accounts.length).to eq 1
      expect(
        @user.events.where(card: nil).first.payment_source_name
      ).to eq '削除済み'
    end

    scenario 'show account and update name' do
      visit accounts_path
      click_link 'account_name2',
                 href: account_path(@user.accounts.order(:id).first.id)
      expect(page).to have_content 'account_name2'
      fill_in 'account[name]', with: 'account2'
      click_on '名前を変更'
      expect(page).to have_content '更新しました。'
      expect(@user.accounts.order(:id).first.name).to eq 'account2'
    end

    scenario 'destroy fund_user' do
      visit fund_users_path
      page.accept_confirm { click_on '削除' }
      sleep 0.5
      expect(@user.fund_users.length).to eq 0
      expect(FundUserHistory.all.length).to eq 0
      expect(@user.accounts.order(:id).first.now_value).to eq 1200
      expect(@user.accounts.order(:id).first.after_pay_value).to eq 850
    end

    scenario 'visit event search' do
      visit events_path
      within find('footer') do
        click_on 'イベント検索'
      end
      expect(page).to have_content '検索結果'
    end

    scenario 'アカウント削除' do
      visit root_path
      within find('footer') do
        click_on '登録情報'
      end
      find('.delete_account').click
      page.accept_confirm { click_button 'アカウント削除' }
      Fund.destroy_all
      User.destroy_all
    end
  end
end
