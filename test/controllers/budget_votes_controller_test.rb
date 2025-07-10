require "test_helper"

class BudgetVotesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get budget_votes_new_url
    assert_response :success
  end

  test "should get create" do
    get budget_votes_create_url
    assert_response :success
  end

  test "should get index" do
    get budget_votes_index_url
    assert_response :success
  end
end
