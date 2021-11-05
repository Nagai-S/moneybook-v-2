require "net/http"
require "json"
require 'dotenv/load'
require './api_request_scripts/get_real_data'

def create_db(params)
  uri = URI.parse("http://localhost:3000/api/v1/initial_regist_db")
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = uri.scheme == "https"

  headers = {
    "Content-Type" => "application/json",
    "access-token" => ENV["AUTH_API_ACCESS_KEY"],
  }
  
  response = http.post(uri.path, params.to_json, headers)
  p response.body
end

def all_axs_create
  all_axs = get_all_axs

  all_axs.each do |data|
    params = {
      "kind" => "1",
      "date(1i)" => data["date"].split("-")[0],
      "date(2i)" => data["date"].split("-")[1],
      "date(3i)" => data["date"].split("-")[2],
      "to_id" => data["to_id"],
      "source_id" => data["source_id"],
      "card" => data["card_id"],
      "value" => data["value"],
      "pon" => data["pon"],
    }

    if data['pay_date']
      params["pay_date(1i)"] = data["pay_date"].split("-")[0]
      params["pay_date(2i)"] = data["pay_date"].split("-")[1]
      params["pay_date(3i)"] = data["pay_date"].split("-")[2]
    end

    create_db(params)
  end
end

def all_events_create
  all_events = get_all_events

  all_events.each do |data|
    params = {
      "kind" => "0",
      "date(1i)" => data["date"].split("-")[0],
      "date(2i)" => data["date"].split("-")[1],
      "date(3i)" => data["date"].split("-")[2],
      "genre_id" => data["genre_id"],
      "account_id" => data["account_id"],
      "card_id" => data["card_id"],
      "memo" => data["memo"],
      "value" => data["value"],
      "iae" => data["iae"],
      "pon" => data["pon"],
    }

    if data['pay_date']
      params["pay_date(1i)"] = data["pay_date"].split("-")[0]
      params["pay_date(2i)"] = data["pay_date"].split("-")[1]
      params["pay_date(3i)"] = data["pay_date"].split("-")[2]
    end
    
    create_db(params)
  end
end

def all_fuh_create
  all_fund_users = get_all_fund_users

  all_fund_users.each do |data|
    params = {
      "kind" => "2",
      "fund_id" => data["fund_id"],
      "average_buy_value" => data["average_buy_value"]
    }

    fuh_array = []
    all_fuh = get_all_fuh(data["id"])
    all_fuh.each do |fuh|
      fuh_params = {
        "buy_or_sell" => fuh["buy_or_sell"],
        "commission" => fuh["commission"],
        "date(1i)" => fuh["date"].split("-")[0],
        "date(2i)" => fuh["date"].split("-")[1],
        "date(3i)" => fuh["date"].split("-")[2],
        "pon" => fuh["pon"],
        "value" => fuh["value"],
        "account_id" => fuh["account_id"],
        "card_id" => fuh["card_id"],
      }

      if fuh['pay_date']
        fuh_params["pay_date(1i)"] = fuh["pay_date"].split("-")[0]
        fuh_params["pay_date(2i)"] = fuh["pay_date"].split("-")[1]
        fuh_params["pay_date(3i)"] = fuh["pay_date"].split("-")[2]
      end

      fuh_array.push(fuh_params)
    end

    params["fuh"] = fuh_array
    create_db(params)
  end
end

def all_funds_create
  all_funds = get_all_funds

  all_funds.each do |fund|
    regist_funds(fund["id"], fund["name"], fund["value"], fund["strin_id"])
  end
end

def regist_funds(id, name, value, string_id)
  uri = URI.parse("http://localhost:3000/api/v1/regist_funds")
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

  p JSON.parse(response.body)
end

all_events_create
all_axs_create
all_funds_create
all_fuh_create
