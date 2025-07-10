require "test_helper"

class ImpactMetricsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get impact_metrics_new_url
    assert_response :success
  end

  test "should get create" do
    get impact_metrics_create_url
    assert_response :success
  end

  test "should get edit" do
    get impact_metrics_edit_url
    assert_response :success
  end

  test "should get update" do
    get impact_metrics_update_url
    assert_response :success
  end

  test "should get destroy" do
    get impact_metrics_destroy_url
    assert_response :success
  end
end
