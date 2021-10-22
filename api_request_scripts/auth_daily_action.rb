require "net/http"
require "json"
require 'dotenv/load'

def send_email
  uri = URI.parse("http://localhost:3000/api/v1/daily_email")
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = uri.scheme === "https"
  headers = {
    "Content-Type" => "application/json",
    "access-token" => ENV['AUTH_API_ACCESS_KEY'],
  }
  req = Net::HTTP::Get.new(uri.path)
  req.initialize_http_header(headers)
  response = http.get(uri.path, headers)

  p response.code
  p JSON.parse(response.body)
end

def update_fund_value
  uri = URI.parse("http://localhost:3000/api/v1/update_fund_value")
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = uri.scheme === "https"
  headers = {
    "access-token" => ENV['AUTH_API_ACCESS_KEY'],
  }
  req = Net::HTTP::Get.new(uri.path)
  req.initialize_http_header(headers)
  response = http.get(uri.path, headers)

  p response.code
  p JSON.parse(response.body)
end

def regist_funds
  name = "aaa"
  value = 10000
  string_id = "ASDFGHJKL"

  uri = URI.parse("http://localhost:3000/api/v1/regist_funds")
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = uri.scheme === "https"

  headers = {
    "access-token" => ENV['AUTH_API_ACCESS_KEY'],
    "Content-Type" => "application/json"
  }

  params = {
    fund: {
      name: name,
      value: value,
      string_id: string_id
    }
  }

  response = http.post(uri.path, params.to_json, headers)

  p response.code
  p JSON.parse(response.body)
end

# send_email
update_fund_value
# regist_funds