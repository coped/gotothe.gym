require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:first)
    @other_user = users(:second)
  end

  test "user login" do
    # User show request without authorization
    get api_v1_user_path(@user)
    assert_equal json_response["status"], "error"
    assert_includes json_response["messages"], "error_message"
    # Unsuccessful login
    post api_v1_login_path, params: { login: { email: "nonexistent@email.com",
                                         password: "foobar" } }
    assert_equal json_response["status"], "error"
    assert_includes json_response["messages"], "error_message"
    assert_empty json_response["response"]
    # Successful login
    post api_v1_login_path, params: { login: { email: @user.email,
                                              password: "foobar" } }
    assert_equal json_response["status"], "success"
    assert_includes json_response["response"], "jwt"
    assert_includes json_response["response"], "user"
    user_token = json_response["response"]["jwt"]
    # Viewing user page
    get api_v1_user_path(@user), headers: { authorization: "Bearer #{user_token}" }
    assert_equal json_response["status"], "success"
    assert_includes json_response["response"], "user"
    assert_equal @user.id, json_response["response"]["user"]["id"]
    # Attempting to view another user's page
    get api_v1_user_path(@other_user), headers: { authorization: "Bearer #{user_token}" }
    assert_equal json_response["status"], "error"
    assert_includes json_response["messages"], "error_message"
    assert_empty json_response["response"]
  end
end
