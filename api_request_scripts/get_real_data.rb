def get_all_axs(auth_info)
  uri2 =
    URI.parse($productionURL + '/api/v1/account_exchanges')
  headers = {
    'Content-Type' => 'application/json',
    'access-token' => auth_info['access_token'],
    'client' => auth_info['client'],
    'uid' => auth_info['uid']
  }
  http = Net::HTTP.new(uri2.host, uri2.port)
  http.use_ssl = uri2.scheme === 'https'
  response = http.get(uri2.path, headers)

  new_auth_info = response['access-token']!='' ? get_auth_info(response) : auth_info

  return {body: JSON.parse(response.body)['axs'], auth_info: new_auth_info}
end

def get_all_events(auth_info)
  uri2 = URI.parse($productionURL + '/api/v1/events')
  headers = {
    'Content-Type' => 'application/json',
    'access-token' => auth_info['access_token'],
    'client' => auth_info['client'],
    'uid' => auth_info['uid']
  }
  http = Net::HTTP.new(uri2.host, uri2.port)
  http.use_ssl = uri2.scheme === 'https'
  response = http.get(uri2.path, headers)

  new_auth_info = response['access-token']!='' ? get_auth_info(response) : auth_info

  return {body: JSON.parse(response.body)['events'], auth_info: new_auth_info}
end

def get_all_fund_users(auth_info)
  uri2 = URI.parse($productionURL + '/api/v1/fund_users')
  headers = {
    'Content-Type' => 'application/json',
    'access-token' => auth_info['access_token'],
    'client' => auth_info['client'],
    'uid' => auth_info['uid']
  }
  http = Net::HTTP.new(uri2.host, uri2.port)
  http.use_ssl = uri2.scheme === 'https'
  response = http.get(uri2.path, headers)

  new_auth_info = response['access-token']!='' ? get_auth_info(response) : auth_info

  return {body: JSON.parse(response.body)['fund_users'], auth_info: new_auth_info}
end

def get_all_fuh(fund_user_id,auth_info)
  uri2 = URI.parse(
    $productionURL + 
    '/api/v1/fund_users/' + 
    fund_user_id.to_s + 
    '/fund_user_histories'
  )
  headers = {
    'Content-Type' => 'application/json',
    'access-token' => auth_info['access_token'],
    'client' => auth_info['client'],
    'uid' => auth_info['uid']
  }
  http = Net::HTTP.new(uri2.host, uri2.port)
  http.use_ssl = uri2.scheme === 'https'
  response = http.get(uri2.path, headers)

  new_auth_info = response['access-token']!='' ? get_auth_info(response) : auth_info

  return {body: JSON.parse(response.body)['fund_user_histories'],auth_info: new_auth_info}
end

def get_all_funds(auth_info)
  uri2 =URI.parse($productionURL + '/api/v1/funds/index')
  headers = {
    'Content-Type' => 'application/json',
    'access-token' => auth_info['access_token'],
    'client' => auth_info['client'],
    'uid' => auth_info['uid']
  }
  http = Net::HTTP.new(uri2.host, uri2.port)
  http.use_ssl = uri2.scheme === 'https'
  response = http.get(uri2.path, headers)

  new_auth_info = response['access-token']!='' ? get_auth_info(response) : auth_info

  return {body: JSON.parse(response.body)['funds'], auth_info: new_auth_info}
end