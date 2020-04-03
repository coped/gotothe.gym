require 'test_helper'

class Api::AuthControllerTest < ActionDispatch::IntegrationTest
    def setup
        @user = users(:first_user)
    end

    test "should respond with JWT and user when provided with correct credentials" do
        post api_v1_login_path, params: { login: { email: @user.email,
                                                 password: "foobar" } }
        assert_equal "success", json_response["status"]
        assert_includes json_response["response"], "jwt"
        assert_equal @user.id, json_response["response"]["user"]["id"]
    end

    test "should not respond with JWT and user when provided with incorrect credentials" do
        post api_v1_login_path, params: { login: { email: "nonexistent@email.com",
                                                 password: "foobar" } }
        assert_equal "error", json_response["status"]
        assert_includes json_response["messages"], "error_message"
        assert_not_includes json_response["response"], "jwt"
        assert_not_includes json_response["response"], "user"
    end
end