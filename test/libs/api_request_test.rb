require 'test_helper'

class ApiRequestTest < ActionDispatch::IntegrationTest
    def setup
        @user = users(:first_user)
        @auth_header = 'Bearer ' + JsonWebToken.encode(payload: { user_id: @user.id })
    end

    test 'ApiRequest authorization should return correct user' do
        get api_v1_user_path(@user), headers: { authorization: @auth_header }
        assert_equal @user, ApiRequest.new(request).authorize
        assert_equal @user, assigns(:current_user)
    end

    test 'ApiRequest authorization should return nil given invalid authorization' do
        get api_v1_user_path(@user), headers: { authorization: 'Bearer invalid-token' }
        assert_nil ApiRequest.new(request).authorize
    end

    test 'ApiRequest authorization should return nil when given nonsense authorization' do
        get api_v1_user_path(@user), headers: { authorization: 'foobar' }
        assert_nil ApiRequest.new(request).authorize
    end
end