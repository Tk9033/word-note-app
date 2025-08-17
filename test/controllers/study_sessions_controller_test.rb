require "test_helper"

class StudySessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get study_sessions_create_url
    assert_response :success
  end

  test "should get show" do
    get study_sessions_show_url
    assert_response :success
  end

  test "should get answer" do
    get study_sessions_answer_url
    assert_response :success
  end

  test "should get back" do
    get study_sessions_back_url
    assert_response :success
  end

  test "should get result" do
    get study_sessions_result_url
    assert_response :success
  end
end
