require "net/http"
require "json"
require 'dotenv/load'

def regist_funds(id, name, value, string_id)
  uri = URI.parse("https://moneybook-moneybook.herokuapp.com/api/v1/regist_funds")
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = uri.scheme === "https"

  headers = {
    "access-token" => ENV['AUTH_API_ACCESS_KEY'],
    "Content-Type" => "application/json"
  }

  params = {
    fund: {
      id: id,
      name: name,
      value: value,
      string_id: string_id
    }
  }

  response = http.post(uri.path, params.to_json, headers)

  p response.code
end

datas = []
File.open('./complete_funds.csv', "r") do |file|
  datas = file.read.split("\n")
end

num = 1
datas.each do |e|
  data = e.split(',')
  regist_funds(
    num,
    data[0],
    data[1],
    data[2],
  )
  num += 1
end
