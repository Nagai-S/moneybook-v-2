require "net/http"
require "json"

params = {
  "email": "a@gmail.com",
  "password": "asdfghjkl",
  "password_confirmation": "asdfghjkl",
}
uri = URI.parse("http://localhost:8080/api/v1/auth")
response = Net::HTTP.post_form(uri, params)

p response.code
