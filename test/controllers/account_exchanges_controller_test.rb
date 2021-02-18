require 'test_helper'

class AccountExchangesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get account_exchanges_index_url
    assert_response :success
  end

  test "should get new" do
    get account_exchanges_new_url
    assert_response :success
  end

  test "should get edit" do
    get account_exchanges_edit_url
    assert_response :success
  end

end
