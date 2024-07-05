class HomepagesController < ApplicationController
  before_action :authenticate_user!, only: :explanation
  def home; end

  def explanation; end

  def update_currency
    currency_id = params[:currency_id]
    current_user.update(currency_id: currency_id)
    redirect_to_referer
  end
end
