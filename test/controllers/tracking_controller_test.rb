require "test_helper"

class TrackingControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get tracking_index_url
    assert_response :success
  end

  test "should get search" do
    get tracking_search_url
    assert_response :success
  end
end
