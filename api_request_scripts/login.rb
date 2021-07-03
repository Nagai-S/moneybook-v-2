require "net/http"
require "json"

params={
  "email": "a@gmail.com",
  "password": "asdfghjkl"
}

uri=URI.parse("http://localhost:3000/api/v1/auth/sign_in")
response=Net::HTTP.post_form(uri, params)

p response["access-token"]
p response["uid"]
p response["client"]
p response.code

