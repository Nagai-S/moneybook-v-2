require 'rails_helper'

RSpec.describe FundUsersController do
  before do
    @user = create(:user)
    @user.confirm
    sign_in @user

    @fund = Fund.create(
      name: "fund1",
      value: 10000,
    )
    @fund_user = @user.fund_users.create(
      average_buy_value: 9000,
      fund_id: @fund.id
    )
  end

  describe "create" do
    let(:params) {{
      fund_user: {
        fund_id: @fund.id,
        average_buy_value: 9000
      }
    }} 
    it "total_buy_valueがある" do
      params[:fund_user][:total_buy_value] = 20000
      expect{post :create, params: params}.to change{
        FundUserHistory.all.length
      }.by(1).and change{
        FundUser.all.length
      }.by(1)
    end

    it "total_buy_valueがない" do
      expect{post :create, params: params}.to change{
        FundUserHistory.all.length
      }.by(0).and change{
        FundUser.all.length
      }.by(1)
    end

    it "total_buy_valueが0" do
      params[:fund_user][:total_buy_value] = "0"
      expect{post :create, params: params}.to change{
        FundUserHistory.all.length
      }.by(0).and change{
        FundUser.all.length
      }.by(1)
    end
  end

  describe "destroy" do
    it "正しくないuserでdestroyできない" do
      uncorrect_user = create(:user)
      uncorrect_user.confirm
      sign_in uncorrect_user
      
      expect{delete :destroy, params: {id: @fund_user.id}}.to change{
        FundUser.all.length
      }.by(0)
    end
  end
end