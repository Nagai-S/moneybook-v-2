require "uri"
require "json"
require "net/http"

namespace :daily_change do
  desc "fundのvalueを更新する"
  task update_fund_value: :environment do
    FundUser.all.includes(:fund)
      .uniq { |fund_user| fund_user.fund_id }
      .each { |fund_user| fund_user.fund.set_now_value_of_fund }
  end

  desc "update the value of currency_exchange"
  task update_currency_exchange_value: :environment do
    sources = Currency.all.map(&:name)
    currencies = sources.join(',')
    sources.each do |source|
      url = URI("https://api.apilayer.com/currency_data/live?source=#{source}&currencies=#{currencies}")

      https = Net::HTTP.new(url.host, url.port);
      https.use_ssl = true
      
      request = Net::HTTP::Get.new(url)
      request['apikey'] = 'rxN2JUiuRW7yiYTI7UJK5OsjDxa8CbFy'
      response = https.request(request)

      if response.code != '200'
        return 0
      end

      result = JSON.parse(response.read_body)
      @result = result['quotes']
      @result.each do |key, value|
        currency = key.gsub(source,'')
        CurrencyExchange
          .find_by(to_id: Currency.find_by(name: currency).id, unit_id: Currency.find_by(name: source).id)
          .update(value: value)
      end
    end
  end
end
