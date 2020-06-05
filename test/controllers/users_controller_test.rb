require 'test_helper'

class Api::UsersControllerTest < ActionDispatch::IntegrationTest
    def setup 
        @user = users(:first_user)
        @other_user = users(:second_user)
        @auth_header = auth_header(@user)
    end

    test 'should give user when authorized' do
        get api_v1_user_path(@user), headers: @auth_header
        assert_equal 'success', json_response['status']
        assert_includes json_response['payload'], 'user'
    end

    test 'should not give user when unauthorized' do
        get api_v1_user_path(@user)
        assert_equal 'error', json_response['status']
        assert json_response['messages'].present?
        assert_nil json_response['payload']
    end

    test 'should not give user when different user' do
        get api_v1_user_path(@other_user), headers: @auth_header
        assert_equal 'error', json_response['status']
        assert json_response['messages'].present?
        assert_nil json_response['payload']
    end

    test 'should respond with user and jwt upon create' do
        post api_v1_users_path, params: { user: { name: 'New User',
                                                email: 'new@user.com',
                                                password: 'foobar',
                                                password_confirmation: 'foobar' } }
        assert_equal 'success', json_response['status']
        assert_includes json_response['payload'], 'jwt'
    end

    test 'should not respond with user and jwt if create is unsuccessful' do
        post api_v1_users_path, params: { user: { name: 'New User', 
                                                email: 'newuser.com',
                                                password: '',
                                                password_confirmation: '' } }
        assert_equal 'error', json_response['status']
        assert json_response['messages'].present?
        assert_nil json_response['payload']
    end

    test 'should respond with user upon update' do
        patch api_v1_user_path(@user), params: { user: { name: 'My New Name' } }, headers: @auth_header
        assert_equal 'success', json_response['status']
        assert_includes json_response['payload'], 'user'
    end

    test 'should not respond with user if update is unsuccessful' do
        patch api_v1_user_path(@user), params: { user: { email: 'newemail.com' } }, headers: @auth_header
        assert_equal 'error', json_response['status']
        assert json_response['messages'].present?
        assert_nil json_response['payload']
    end

    test 'should not respond with user if different user' do
        patch api_v1_user_path(@other_user), params: { user: { email: 'newemail.com' } }, headers: @auth_header
        assert_equal 'error', json_response['status']
        assert json_response['messages'].present?
        assert_nil json_response['payload']
    end

    test 'should not respond with user if unauthorized' do
        patch api_v1_user_path(@user), params: { user: { name: 'My New Name' } }
        assert_equal 'error', json_response['status']
        assert json_response['messages'].present?
        assert_nil json_response['payload']
    end

    test 'should respond with success if user destroyed' do
        delete api_v1_user_path(@user), headers: @auth_header
        assert_equal 'success', json_response['status']
        assert_nil json_response['payload']
    end

    test 'should not respond with success if user unauthorized' do
        delete api_v1_user_path(@user)
        assert_equal 'error', json_response['status']
        assert json_response['messages'].present?
        assert_nil json_response['payload']
    end

    test 'should not respond with success if different user' do
        delete api_v1_user_path(@other_user)
        assert_equal 'error', json_response['status']
        assert json_response['messages'].present?
        assert_nil json_response['payload']
    end
end