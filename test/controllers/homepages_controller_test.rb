require 'test_helper'

class HomepagesControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get homepages_home_url
    assert_response :success
  end

end
