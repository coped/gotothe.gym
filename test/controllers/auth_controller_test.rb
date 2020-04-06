require 'test_helper'

class Api::AuthControllerTest < ActionDispatch::IntegrationTest
    def setup
        @user = users(:first_user)
        @auth_header = "Bearer " + JsonWebToken.encode(payload: { user_id: @user.id })
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

    test "AuthorizeApiRequest service object should return correct user" do
        get api_v1_user_path(@user), headers: { authorization: @auth_header }
        assert_equal @user, AuthorizeApiRequest.new(headers: request.headers).call
        assert_equal @user, assigns(:current_user)
    end

    test "AuthorizeApiRequest service object should return nil given invalid authorization" do
        get api_v1_user_path(@user), headers: { authorization: "Bearer invalid-token" }
        assert_nil AuthorizeApiRequest.new(headers: request.headers).call
    end

    test "AuthorizeApiRequest service object should return nil when given nonsense authorization" do
        get api_v1_user_path(@user), headers: { authorization: "foobar" }
        assert_nil AuthorizeApiRequest.new(headers: request.headers).call
    end
end