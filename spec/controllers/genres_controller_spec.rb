require 'rails_helper'

RSpec.describe GenresController do
  before do
    @user = create(:user)
    @user.confirm
    sign_in @user
    @genre_ex = @user.genres.create(name: "genre_ex", iae: false)
    @account1 = @user.accounts.create(name: "account1", value: 1000)
  end

  describe "destroy" do
    let(:params) { {id: @genre_ex.id} } 
    context "成功" do
      it "eventのgenre_idがnilになる" do
        event = @user.events.create(
          iae: false,
          memo: "",
          value: 100,
          genre_id: @genre_ex.id,
          account_id: @account1.id,
          date: Date.today,
          pon: true
        )

        expect{delete :destroy, params: params}.to change{
          Genre.all.length
        }.by(-1)
        expect(Event.find(event.id).genre_id).to eq nil
      end
      
    end
    context "失敗" do
      it "正しくないuserでdestroyできない" do
        uncorrect_user = create(:user)
        uncorrect_user.confirm
        sign_in uncorrect_user
        expect{delete :destroy, params: params}.to change{
          Genre.all.length
        }.by(0)
      end
    end
  end
  
end