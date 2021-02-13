require 'test_helper'

class AccountsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get accounts_index_url
    assert_response :success
  end

  test "should get new" do
    get accounts_new_url
    assert_response :success
  end

  test "should get edit" do
    get accounts_edit_url
    assert_response :success
  end

end
