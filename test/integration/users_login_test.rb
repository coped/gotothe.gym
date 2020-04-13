require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:first_user)
    @other_user = users(:second_user)
  end

  test 'user login' do
    # User show request without authorization
    get api_v1_user_path(@user)
    assert_equal 'error', json_response['status']
    assert json_response['messages'].present?
    # Unsuccessful login
    post api_v1_login_path, params: { login: { email: 'nonexistent@email.com',
                                         password: 'foobar' } }
    assert_equal 'error', json_response['status']
    assert json_response['messages'].present?
    assert_nil json_response['payload']
    # Successful login
    post api_v1_login_path, params: { login: { email: @user.email,
                                              password: 'foobar' } }
    assert_equal 'success', json_response['status']
    assert_includes json_response['payload'], 'jwt'
    assert_includes json_response['payload'], 'user'
    user_token = json_response['payload']['jwt']
    auth_header = 'Bearer ' + user_token
    # Viewing user page
    get api_v1_user_path(@user), headers: { authorization: auth_header }
    assert_equal 'success', json_response['status']
    assert_includes json_response['payload'], 'user'
    assert_equal @user.id, json_response['payload']['user']['id']
    # Attempting to view another user's page
    get api_v1_user_path(@other_user), headers: { authorization: auth_header }
    assert_equal 'error', json_response['status']
    assert json_response['messages'].present?
    assert_nil json_response['payload']
    # Logging out 
    delete api_v1_user_path(@user), headers: { authorization: auth_header }
    assert_includes json_response['status'], 'success'
  end
end
