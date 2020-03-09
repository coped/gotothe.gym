require 'test_helper'

class Api::AuthControllerTest < ActionDispatch::IntegrationTest
    def setup
        @user = users(:first)
    end

    test "should respond with JWT and user when provided with correct credentials" do
        post api_v1_login_path, params: { login: { email: @user.email,
                                                 password: "foobar" } }
        assert_equal json_response["status"], "success"
        assert_includes json_response["response"], "jwt"
        assert_equal @user.id, json_response["response"]["user"]["id"]
    end

    test "should not respond with JWT and user when provided with incorrect credentials" do
        post api_v1_login_path, params: { login: { email: "nonexistent@email.com",
                                                 password: "foobar" } }
        assert_equal json_response["status"], "error"
        assert_includes json_response["messages"], "error_message"
        assert_not_includes json_response["response"], "jwt"
        assert_not_includes json_response["response"], "user"
    end

    test "should be successful when provided correct jwt" do
        auth_header = "Bearer #{JWT.encode({ user_id: @user.id }, ENV['JWT_SECRET'])}"
        post api_v1_auto_login_path, headers: { authorization: auth_header }
        assert_equal json_response["status"], "success"
    end

    test "should not be successful when provided incorrect jwt" do
        post api_v1_auto_login_path, headers: { authorization: "fake token" }
        assert_equal json_response["status"], "error"
        assert_includes json_response["messages"], "error_message"
    end
end