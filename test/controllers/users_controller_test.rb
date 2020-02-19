require 'test_helper'

class Api::UsersControllerTest < ActionDispatch::IntegrationTest
    def setup 
        @user = users(:first)
        @other_user = users(:second)
        @auth_header = "Bearer #{JWT.encode({ user_id: @user.id }, ENV['JWT_SECRET'])}"
    end

    test "should give user when authorized" do
        get api_v1_user_path(@user), headers: { authorization: @auth_header }
        assert json_response["success"]
        assert_includes json_response, "user"
    end

    test "should not give user when unauthorized" do
        get api_v1_user_path(@user)
        assert_not json_response["success"]
        assert_includes json_response, "error_message"
    end

    test "should not give user when different user" do
        get api_v1_user_path(@other_user), headers: { authorization: @auth_header }
        assert_not json_response["success"]
        assert_includes json_response, "error_message"
    end

    test "should respond with user and jwt upon create" do
        post api_v1_users_path, params: { user: { name: "New User",
                                                email: "new@user.com",
                                                password: "foobar",
                                                password_confirmation: "foobar" } }
        assert json_response["success"]
        assert_includes json_response, "user"
        assert_includes json_response, "jwt"
    end

    test "should not respond with user and jwt if create is unsuccessful" do
        post api_v1_users_path, params: { user: { name: "New User", 
                                                email: "newuser.com",
                                                password: "",
                                                password_confirmation: "" } }
        assert_not json_response["success"]
        assert_includes json_response, "error_message"
    end

    test "should respond with user upon update" do
        patch api_v1_user_path(@user), params: { user: { name: "My New Name" } }, headers: { authorization: @auth_header }
        assert json_response["success"]
        assert_includes json_response, "user"
    end

    test "should not respond with user if update is unsuccessful" do
        patch api_v1_user_path(@user), params: { user: { email: "newemail.com" } }, headers: { authorization: @auth_header }
        assert_not json_response["success"]
        assert_not_includes json_response, "user"
        assert_includes json_response, "error_message"
    end

    test "should not respond with user if different user" do
        patch api_v1_user_path(@other_user), params: { user: { email: "newemail.com" } }, headers: { authorization: @auth_header }
        assert_not json_response["success"]
        assert_not_includes json_response, "user"
        assert_includes json_response, "error_message"
    end

    test "should not respond with user if unauthorized" do
        patch api_v1_user_path(@user), params: { user: { name: "My New Name" } }
        assert_not json_response["success"]
        assert_includes json_response, "error_message"
    end

    test "should respond with success if user destroyed" do
        delete api_v1_user_path(@user), headers: { authorization: @auth_header }
        assert json_response["success"]
    end

    test "should not respond with success if user unauthorized" do
        delete api_v1_user_path(@user)
        assert_not json_response["success"]
        assert_includes json_response, "error_message"
    end

    test "should not respond with success if different user" do
        delete api_v1_user_path(@other_user)
        assert_not json_response["success"]
        assert_includes json_response, "error_message"
    end
end