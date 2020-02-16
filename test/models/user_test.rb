require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "New User",
                     email: "new@user.com",
                     password: "foobar",
                     password_confirmation: "foobar")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "     "
    assert_not @user.valid?
  end

  test "name length should not exceed 255 characters" do
    @user.name = "e" * 256
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "     "
    assert_not @user.valid?
  end

  test "email length should not exceed 255 characters" do
    @user.email = "e" * 256
    assert_not @user.valid?
  end

  test "email should be unique" do
    second_user = users(:second)
    @user.email = second_user.email
    assert_not @user.valid?
  end

  test "email uniqueness should be case insensitive" do
    second_user = users(:second)
    second_user.email.upcase!
    @user.email = second_user.email.downcase
    assert_not @user.valid?
  end

  test "email should be downcased upon save" do
    email = "NEW@USER.COM"
    @user.email = email
    @user.save
    assert_equal email.downcase, @user.email
  end

  test "email should have correct format" do
    @user.email = "@user.com"
    assert_not @user.valid?
    @user.email = "first@com"
    assert_not @user.valid?
    @user.email = "firstuser.com"
    assert_not @user.valid?
  end

  test "password should be present" do
    @user.password = @user.password_confirmation = ""
    assert_not @user.valid?
  end

  test "password length should be greater than 6 characters" do
    @user.password = @user.password_confirmation = "e" * 5
    assert_not @user.valid?
  end

  test "password should require confirmation" do
    @user.password = "foobar"
    @user.password_confirmation = ""
    assert_not @user.valid?
  end
end
