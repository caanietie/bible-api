require "test_helper"

class APIControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_index_url
    assert_response :success
    assert_equal "html", @request.format
    assert_equal "index", @controller.action_name
  end

  teardown do
    Rails.cache.clear
  end
end
