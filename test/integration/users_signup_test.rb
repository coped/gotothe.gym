require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  def setup
    @first_user = users(:first_user)
  end

  test "user signup" do
    # Unsuccessfully creating a user
    assert_no_difference -> { User.count } do
      post api_v1_users_path, params: { user: { name: "New User",
                                                email: "newuser.com",
                                                password: "",
                                                password_confirmation: "" } }
    end
    assert_equal json_response["status"], "error"
    assert_includes json_response["messages"], "error_message"
    assert_empty json_response["response"]
    assert_equal json_response["messages"]["errors"].size, 2
    # Successfully signing up
    assert_difference -> { User.count }, 1 do
      post api_v1_users_path, params: { user: { name: "New User",
                                                email: "new@user.com",
                                                password: "foobar",
                                                password_confirmation: "foobar" } }
    end
    user = User.last
    assert_equal json_response["status"], "success"
    assert_includes json_response["response"], "user"
    assert_includes json_response["response"], "jwt"
    assert_equal user.id, json_response["response"]["user"]["id"]
    assert_equal user.id, JWT.decode(json_response["response"]["jwt"], ENV['JWT_SECRET'], true, algorithm: "HS256")[0]["user_id"]
  end
end
