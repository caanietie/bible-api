require "test_helper"

class KJVBibleControllerTest < ActionDispatch::IntegrationTest
  test "should get root" do
    get root_url
    assert_response :success
    assert_equal "html", @request.format
    assert_equal "index", @controller.action_name
  end

  test "should get index" do
    get kjv_bible_index_url
    assert_response :success
    assert_equal "html", @request.format
    assert_equal "index", @controller.action_name
  end

  teardown do
    Rails.cache.clear
  end
end
