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
        title: :full_title,          # :full_title とすると、サイトに表示される <title> と全く同じものを表示できる
        description: :description,   # 上に同じ
        url: request.url,
        image: image_tag("favicon.png")
      }
    end

    def default_twitter_card
      {
        card: 'summary_large_image',
      }   
    end
end
