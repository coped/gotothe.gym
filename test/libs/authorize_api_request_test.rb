require 'test_helper'

class AuthorizeApiRequestTest < ActionDispatch::IntegrationTest
    def setup
        @user = users(:first_user)
        @auth_header = auth_header(@user)
    end

    test 'AuthorizeApiRequest service object should return correct user' do
        get api_v1_user_path(@user), headers: @auth_header
        assert_equal @user, AuthorizeApiRequest.new(headers: request.headers).call
        assert_equal @user, assigns(:current_user)
    end

    test 'AuthorizeApiRequest service object should return nil given invalid authorization' do
        get api_v1_user_path(@user), headers: { authorization: 'Bearer invalid-token' }
        assert_nil AuthorizeApiRequest.new(headers: request.headers).call
    end

    test 'AuthorizeApiRequest service object should return nil when given nonsense authorization' do
        get api_v1_user_path(@user), headers: { authorization: 'foobar' }
        assert_nil AuthorizeApiRequest.new(headers: request.headers).call
    end
end