require "net/http"
require "json"
require 'dotenv/load'

def a_id_trans(a_id)
  if a_id==13
    account_id=1
  elsif a_id==12
    account_id=3
  elsif a_id==15
    account_id=9
  elsif a_id==14
    account_id=8
  else
    account_id=a_id
  end

  return account_id
end

def g_id_trans(g_id)
  if g_id==18
    genre_id=14
  elsif g_id==20
    genre_id=15
  else
    genre_id=g_id
  end

  return genre_id
end

def c_id_trans(c_id)
  if c_id==7
    card_id=3
  else
    card_id=c_id
  end

  return card_id
end

def login
  params={
    "email" => "a@gmail.com",
    "password" => "asdfghjkl",
  }

  uri=URI.parse("http://localhost:3000/api/v1/auth/sign_in")
  response=Net::HTTP.post_form(uri, params)

  return_hash = {
    "access_token" => response["access-token"],
    "client" => response["client"],
  }

  return return_hash
end

def get_all_axs
  uri2 = URI.parse("https://moneybook-moneybook.herokuapp.com/api/v1/account_exchanges")
  headers = {
    "Content-Type" => "application/json",
    "access-token" => ENV['PRODUCTION_ACCESS_TOKEN'],
    "client" => ENV['PRODUCTION_CLIENT'],
    "uid" => ENV['PRODUCTION_UID'],
  }
  http = Net::HTTP.new(uri2.host, uri2.port)
  http.use_ssl = uri2.scheme === "https"
  response = http.get(uri2.path, headers)

  return JSON.parse(response.body)["axs"]
end

def get_all_events
  uri2 = URI.parse("https://moneybook-moneybook.herokuapp.com/api/v1/events")
  headers = {
    "Content-Type" => "application/json",
    "access-token" => ENV['PRODUCTION_ACCESS_TOKEN'],
    "client" => ENV['PRODUCTION_CLIENT'],
    "uid" => ENV['PRODUCTION_UID'],
  }
  http = Net::HTTP.new(uri2.host, uri2.port)
  http.use_ssl = uri2.scheme === "https"
  response = http.get(uri2.path, headers)

  return JSON.parse(response.body)["events"]
end

def create_ax(params, header_info)
  uri=URI.parse("http://localhost:3000/api/v1/account_exchanges")
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = uri.scheme === "https"

  headers={
    "Content-Type" => "application/json",
    "access-token" => header_info["access_token"],
    "client" => header_info["client"],
    "uid" => "a@gmail.com",
  }
  
  response=http.post(uri.path, params.to_json, headers)
end

def create_event(params, header_info)
  uri=URI.parse("http://localhost:3000/api/v1/events")
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = uri.scheme === "https"

  headers={
    "Content-Type" => "application/json",
    "access-token" => header_info["access_token"],
    "client" => header_info["client"],
    "uid" => "a@gmail.com",
  }
  
  response=http.post(uri.path, params.to_json, headers)
  p response.body
end

def all_axs_create
  all_axs = get_all_axs

  header_info = login
  
  all_axs.each do |data|
    year = data["date"].split("-")[0]
    month = data["date"].split("-")[1]
    day = data["date"].split("-")[2]
    value = data["value"]
    a_id = data["source_id"]
    c_id = data["card_id"]
    to_id = data["to_id"]
    pon = data["pon"]
  
    aoc = a_id ? "0" : "1"
    account_id = a_id_trans(a_id)
    to_id = a_id_trans(to_id)
    card_id = c_id_trans(c_id)
    
    params={
      account_exchange: {
        "date(1i)" => year,
        "date(2i)" => month,
        "date(3i)" => day,
        "to_account" => to_id,
        "source_account" => account_id,
        "card" => card_id,
        "value" => value,
        "account_or_card" => aoc,
      }
    }
    
    create_ax(params, header_info)
  end
end

def all_events_create
  all_events = get_all_events

  header_info = login
  
  all_events.each do |data|
    year = data["date"].split("-")[0]
    month = data["date"].split("-")[1]
    day = data["date"].split("-")[2]
    iae = data["iae"]
    memo = data["memo"]
    value = data["value"]
    a_id = data["account_id"]
    c_id = data["card_id"]
    g_id = data["genre_id"]
    pon = data["pon"]
  
    aoc = a_id ? "0" : "1"
    account_id = a_id_trans(a_id)
    genre_id = g_id_trans(g_id)
    card_id = c_id_trans(c_id)
    
    params={
      event: {
        "date(1i)" => year,
        "date(2i)" => month,
        "date(3i)" => day,
        "genre" => genre_id,
        "account" => account_id,
        "card" => card_id,
        "memo" => memo,
        "value" => value,
        "account_or_card" => aoc,
        "iae" => iae,
      }
    }
    
    create_event(params, header_info)
  end
end

def a_event_create
  header_info = login
  
  params={
    event: {
      "date(1i)" => "2021",
      "date(2i)" => "7",
      "date(3i)" => "1",
      "genre" => 6,
      "account" => 4,
      "card" => nil,
      "memo" => "test",
      "value" => 10000,
      "account_or_card" => "0",
      "iae" => true,
    }
  }
  create_event(params, header_info)
end

def a_ax_create
  header_info = login
  
  params={
    account_exchange: {
      "date(1i)" => "2021",
      "date(2i)" => "7",
      "date(3i)" => "2",
      "to_account" => 1,
      "source_account" => 2,
      "card" => 1,
      "value" => 1000,
      "account_or_card" => "1",
    }
  }
  create_ax(params, header_info)
end

# a_event_create
# a_ax_create

all_events_create
p "all events create"
# all_axs_create
# p "all account exchanges create"