module ApplicationHelper
  def form_class
    "form-group col-12 col-sm-8 offset-sm-2 col-lg-6 offset-lg-3"
  end

  def label_class
    "col-12 col-sm-8 offset-sm-2 col-lg-6 offset-lg-3 text-left"
  end

  def date_for_new(object)
    object.date ? object.date : Date.today
  end

  def account_or_card_name(event)
    if event.account
      event.account.name
    elsif event.card
      event.card.name
    end
  end
end
