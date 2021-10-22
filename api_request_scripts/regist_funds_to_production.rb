require "net/http"
require "json"
require 'dotenv/load'

def regist_funds(name, value, string_id)
  uri = URI.parse("https://moneybook-moneybook.herokuapp.com/api/v1/regist_funds")
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
end

datas = []
File.open('./effective_all_funds.txt', "r") do |file|
  datas = file.read.split("\n")
end

(datas.length/3).to_i.times do |i|
  num = i * 3
  regist_funds(
    datas[num],
    datas[num+1],
    datas[num+2],
  )
end
