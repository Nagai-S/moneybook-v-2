require 'net/http'
require 'json'

$productionURL = 'https://assetsmanagement.xyz'

def login
  # params = { 'email' => 'a@gmail.com', 'password' => 'asdfghjkl' }
  params = { 'email' => 'shogo0407baseball@icloud.com', 'password' => 'RMcr7m0neyb00k' }

  # uri = URI.parse('http://localhost:8080/api/v1/auth/sign_in')
  uri = URI.parse($productionURL + '/api/v1/auth/sign_in')
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = uri.scheme === 'https'
  headers = {
    'Content-Type' => 'application/json'
  }
  response = http.post(uri.path, params.to_json, headers)

  # puts response.to_hash

  return get_auth_info(response)
end

def get_auth_info(response)
  return_hash = {
    'access_token' => response['access-token'],
    'client' => response['client'],
    'uid' => response['uid']
  }
  return return_hash
end

# puts login
