require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  def setup
    @first_user = users(:first_user)
  end

  test 'user signup' do
    # Unsuccessfully creating a user
    assert_no_difference -> { User.count } do
      post api_v1_users_path, params: { user: { name: 'New User',
                                                email: 'newuser.com',
                                                password: '',
                                                password_confirmation: '' } }
    end
    assert_equal 'error', json_response['status']
    assert json_response['messages'].present?
    assert_nil json_response['payload']
    # Successfully signing up
    assert_difference -> { User.count }, 1 do
      post api_v1_users_path, params: { user: { name: 'New User',
                                                email: 'new@user.com',
                                                password: 'foobar',
                                                password_confirmation: 'foobar' } }
    end
    user = User.last
    assert_equal 'success', json_response['status']
    assert_includes json_response['payload'], 'jwt'
    # Get redirected to user page
    new_user = User.find_by(email: 'new@user.com')
    get api_v1_user_path(new_user), headers: auth_header(new_user)
    assert_includes json_response['payload'], 'user'
    assert_equal user.id, json_response['payload']['user']['id']
    assert_equal user.id, JWT.decode(
      json_response['payload']['jwt'],
      ENV['JWT_SECRET'],
      true,
      algorithm: 'HS256'
    ).first['user_id']
  end
end
