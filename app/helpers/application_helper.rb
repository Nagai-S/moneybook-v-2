module ApplicationHelper
  def omit_string(str)
    if str.length > 10
      str[0, 10] + "..."
    else
      str
    end
  end
  
  def form_class
    "form-group col-12 col-sm-8 offset-sm-2 col-lg-6 offset-lg-3"
  end

  def label_class
    "col-12 col-sm-8 offset-sm-2 col-lg-6 offset-lg-3 text-left"
  end

  def date_for_new(object)
    object.date ? object.date : Date.today
  end

  def each_value_for_month(date)
    income = current_user
    .events.where(date: date.all_month, iae: true).sum(:value)
    ex = current_user
    .events.where(date: date.all_month, iae: false).sum(:value)
    return {in: income, ex: ex, plus_minus: income-ex}
  end

  def account_or_card_name(event, fund_or_not)
    if event.card
      event.card.name
    elsif event.account
      event.account.name
    else
      deleted_message(fund_or_not)
    end
  end

  def deleted_message(fund_or_not)
    fund_or_not ? "ー" : "削除済み"
  end
  
  def loss_or_gain(value)
    value > 0 ? "gain_value" : "loss_value"
  end

  def default_meta_tags
    {
      site: "MoneyBook",
      reverse: true,
      og: default_og,
      twitter: default_twitter_card,
    }
  end

  private

    def default_og
      {
        title: :full_title,   
        description: :description,
        url: request.url,
        image: "https://moneybook-moneybook.herokuapp.com/assets/favicon-173c0422671de631d1f180efe1be2ff52b8b5add1571c4b8d4209ceb0ba2ca0e.png"
      }
    end

    def default_twitter_card
      {
        card: 'summary_large_image',
      }   
    end
end
