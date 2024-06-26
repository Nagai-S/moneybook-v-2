require 'rails_helper'

RSpec.describe GenresController do
  before do
    @user = create(:user)
    # @user.confirm
    sign_in @user
    @genre_ex = @user.genres.create(name: 'genre_ex', iae: false)
  end

  describe 'destroy' do
    let(:params) { { id: @genre_ex.id } }
    it '正しくないuserでdestroyできない' do
      uncorrect_user = create(:user)
      # uncorrect_user.confirm
      sign_in uncorrect_user

      expect { delete :destroy, params: params }.to change { Genre.all.length }
        .by(0)
    end
  end
end
