require 'test_helper'

class CardsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get cards_index_url
    assert_response :success
  end

  test "should get new" do
    get cards_new_url
    assert_response :success
  end

  test "should get edit" do
    get cards_edit_url
    assert_response :success
  end

end
