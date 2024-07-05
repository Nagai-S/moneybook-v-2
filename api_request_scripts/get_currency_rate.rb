require "uri"
require "net/http"
require "json"

url = URI("https://api.apilayer.com/currency_data/live?source=EUR&currencies=JPY,EUR")

https = Net::HTTP.new(url.host, url.port);
https.use_ssl = true

request = Net::HTTP::Get.new(url)
request['apikey'] = "rxN2JUiuRW7yiYTI7UJK5OsjDxa8CbFy"

response = https.request(request)
puts response.code == '200'
result = JSON.parse(response.read_body)
puts result['quotes']