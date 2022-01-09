require "test_helper"

class Api::V1::CartControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get api_v1_cart_create_url
    assert_response :success
  end
end
