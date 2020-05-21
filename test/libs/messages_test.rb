require 'test_helper'

class MessagesTest < ActiveSupport::TestCase
    def setup
        @user = users(:first_user)
        @message = Messages.unauthorized
    end

    test "should return a hash, representing message attributes" do
        assert_equal Hash, @message.class
    end

    test "should have a 'type' attribute" do
        assert_includes @message.keys, :type
    end

    test "should have a 'messsage' attribute" do
        assert_includes @message.keys, :message
    end

    test "should return error messages specific to user" do
        @user.update(name: "")
        assert Messages.user_errors(@user).present?
    end
end