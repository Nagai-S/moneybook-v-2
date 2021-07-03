require "net/http"
require "json"
require 'dotenv/load'

uri=URI.parse("http://localhost:3000/api/v1/daily_email")
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = uri.scheme === "https"
headers={
  "Content-Type" => "application/json",
  "access-token" => ENV['AUTH_API_ACCESS_KEY'],
}
req=Net::HTTP::Get.new(uri.path)
req.initialize_http_header(headers)
response=http.get(uri.path, headers)

p response.code
p JSON.parse(response.body)