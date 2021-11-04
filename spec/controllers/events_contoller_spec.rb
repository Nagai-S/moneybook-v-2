require 'rails_helper'

RSpec.describe EventsController do
  before do
    @user = create(:user)
    @user.confirm
    sign_in @user
    @genre_ex = @user.genres.create(name: "genre_ex", iae: false)
    @genre_in = @user.genres.create(name: "genre_in", iae: true)
    @account1 = @user.accounts.create(name: "account1", value: 1000)
    @account2 = @user.accounts.create(name: "account2", value: 2000)
    @card1 = @user.cards.create(
      name: "card1", 
      pay_date: 10, 
      month_date: 20, 
      account_id: @account1.id
    )
    @card2 = @user.cards.create(
      name: "card2", 
      pay_date: 20, 
      month_date: 10, 
      account_id: @account2.id
    )
  end
  
  describe "create" do
    let(:params) { 
      {
        event: {
          "date(1i)" => Date.today.year,
          "date(2i)" => Date.today.month,
          "date(3i)" => Date.today.day,
          value: 100,
        }
      }
     }
    describe "association_model_update" do
      it "正しいaccount, genre_inで登録される" do
        params[:event][:account_or_card] = "0"
        params[:event][:account] = @account1.id
        params[:event][:card] = @card1.id
        params[:event][:genre] = @genre_in.id
        params[:event][:iae] = true

        expect{post :create, params: params}.to change{
          Event.all.length
        }.by(1)
        expect(Event.order(:id).last.account_id).to eq @account1.id
        expect(Event.order(:id).last.genre_id).to eq @genre_in.id
        expect(Event.order(:id).last.card_id).to eq nil
      end

      it "正しいcard, genre_exで登録される" do
        params[:event][:account_or_card] = "1"
        params[:event][:account] = @account2.id
        params[:event][:card] = @card1.id
        params[:event][:genre] = @genre_ex.id
        params[:event][:iae] = false

        expect{post :create, params: params}.to change{
          Event.all.length
        }.by(1)
        expect(Event.order(:id).last.account_id).to eq @card1.account_id
        expect(Event.order(:id).last.genre_id).to eq @genre_ex.id
        expect(Event.order(:id).last.card_id).to eq @card1.id
      end
    end
  end
  

  describe "destroy" do
    it "正しいuserでなくて失敗" do
      uncorrect_user = create(:user)
      uncorrect_user.confirm
      sign_in uncorrect_user
      event = @user.events.create(
        value: 100,
        account_id: @account1.id,
        card_id: nil,
        date: Date.today.prev_year(1),
        genre_id: @genre_ex.id,
        iae: false,
        pon: true,
      )
      expect{
        delete :destroy, params: {id: event.id}
      }.to change{
        Event.all.length
      }.by(0)
    end
  end
  
  describe "update" do
    let(:params) { 
      {
        event:{
          "date(1i)": Date.today.year,
          "date(2i)": Date.today.month,
          "date(3i)": Date.today.day,
          account_or_card: "0",
          account: @account2.id,
          card: @card2.id,
          genre: @genre_ex.id,
          iae: false
        }
      }
     } 
    describe "updateに失敗" do
      it "valueがなくて失敗するがaccount, card, gnereに変化がない" do
        event = @user.events.create(
          value: 100,
          account_id: @account1.id,
          card_id: nil,
          date: Date.today,
          genre_id: @genre_in.id,
          pon: true,
          iae: true,
        )
        params[:id] = event.id
        params[:event][:value] = ""
        expect{
          put :update, params: params  
        }.to change{
          Event.find(event.id).account_id
        }.by(0).and change{
          Event.find(event.id).genre_id
        }.by(0)
      end

      it "正しいuserでなくて失敗" do
        uncorrect_user = create(:user)
        uncorrect_user.confirm
        sign_in uncorrect_user
        event = @user.events.create(
          value: 100,
          account_id: @account1.id,
          card_id: nil,
          date: Date.today,
          genre_id: @genre_ex.id,
          pon: true,
          iae: false,
        )
        params[:id] = event.id
        params[:event][:value] = "100"
        expect{
          put :update, params: params  
        }.to change{
          Event.find(event.id).account_id
        }.by(0).and change{
          Event.find(event.id).genre_id
        }.by(0)
      end
    end
  end
end