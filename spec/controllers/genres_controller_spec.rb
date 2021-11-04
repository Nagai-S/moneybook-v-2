require 'rails_helper'

RSpec.describe GenresController do
  before do
    @user = create(:user)
    @user.confirm
    sign_in @user
    @genre_ex = @user.genres.create(name: "genre_ex", iae: false)
  end

  describe "destroy" do
    let(:params) { {id: @genre_ex.id} } 
    it "正しくないuserでdestroyできない" do
      uncorrect_user = create(:user)
      uncorrect_user.confirm
      sign_in uncorrect_user

      expect{delete :destroy, params: params}.to change{
        Genre.all.length
      }.by(0)
    end
  end

  describe "update" do
    it "正しくないuserでupdateできない" do
      uncorrect_user = create(:user)
      uncorrect_user.confirm
      sign_in uncorrect_user

      params = {
        genre: {
          name: "updated_name",
          iae: true,
        },
        id: @genre_ex.id,
      }
      put(:update, params: params)
      expect(Genre.find(@genre_ex.id).name).to eq "genre_ex"
      expect(Genre.find(@genre_ex.id).iae).to eq false
    end
  end
end