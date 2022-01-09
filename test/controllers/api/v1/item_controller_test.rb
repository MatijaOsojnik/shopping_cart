require "test_helper"

class Api::V1::ItemControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get api_v1_item_create_url
    assert_response :success
  end
end
