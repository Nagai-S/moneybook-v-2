def login
  params = {
    "email" => "a@gmail.com",
    "password" => "asdfghjkl",
  }

  uri = URI.parse("http://localhost:8080/api/v1/auth/sign_in")
  response = Net::HTTP.post_form(uri, params)

  return_hash = {
    "access_token" => response["access-token"],
    "client" => response["client"],
  }

  return return_hash
end