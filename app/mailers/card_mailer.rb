class CardMailer < ApplicationMailer
  def monthly_card_info
    @card=params[:card]
    @user=params[:user]
    @pay_date=params[:pay_date]
    mail(to: @user.email, subject: "今月の#{@card.name}でのお支払い合計金額")
  end
end
