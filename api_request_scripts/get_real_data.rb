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