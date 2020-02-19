require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  def setup
    @first_user = users(:first)
  end

  test "user signup" do
    # Unsuccessfully creating a user
    assert_no_difference -> { User.count } do
      post api_v1_users_path, params: { user: { name: "New User",
                                                email: "newuser.com",
                                                password: "",
                                                password_confirmation: "" } }
    end
    assert_not json_response["success"]
    assert_includes json_response, "error_message"
    assert_equal json_response["errors"].size, 2
    # Successfully signing up
    assert_difference -> { User.count }, 1 do
      post api_v1_users_path, params: { user: { name: "New User",
                                                email: "new@user.com",
                                                password: "foobar",
                                                password_confirmation: "foobar" } }
    end
    user = User.last
    assert json_response["success"]
    assert_includes json_response, "user"
    assert_includes json_response, "jwt"
    assert_equal user.id, json_response["user"]["id"]
    assert_equal user.id, JWT.decode(json_response["jwt"], ENV['JWT_SECRET'], true, algorithm: "HS256")[0]["user_id"]
  end
end
