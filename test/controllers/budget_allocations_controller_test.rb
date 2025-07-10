require "test_helper"

class BudgetAllocationsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get budget_allocations_new_url
    assert_response :success
  end

  test "should get create" do
    get budget_allocations_create_url
    assert_response :success
  end

  test "should get edit" do
    get budget_allocations_edit_url
    assert_response :success
  end

  test "should get update" do
    get budget_allocations_update_url
    assert_response :success
  end

  test "should get destroy" do
    get budget_allocations_destroy_url
    assert_response :success
  end
end
