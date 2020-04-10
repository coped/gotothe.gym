require 'test_helper'

class MessagesTest < ActiveSupport::TestCase
    def setup
        @user = users(:first_user)
        @message = Messages.unauthorized
    end

    test "should return an indifferent hash, representing message attributes" do
        assert_equal HashWithIndifferentAccess, @message.class
    end

    test "should have a 'type' attribute" do
        assert_includes @message.keys, 'type'
    end

    test "should have a 'messsage' attribute" do
        assert_includes @message.keys, 'message'
    end

    test "message values should have indifferent access" do
        assert_equal @message['message'], @message[:message]
    end

    test "should raise ArgumentError if user has no errors" do
        assert_raises ArgumentError do
            Messages.user_errors(@user)
        end
    end

    test "should return error messages specific to user" do
        @user.update(name: "")
        assert Messages.user_errors(@user).present?
    end
end