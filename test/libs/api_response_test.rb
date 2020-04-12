require 'test_helper'

class ApiResponseTest < ActiveSupport::TestCase
    def setup
        @user = users(:first_user)
    end

    test "should have proper defaults" do
        json = ApiResponse.json
        assert_equal :success, json[:status]
        assert_nil json[:messages]
        assert_nil json[:payload]
    end

    test "should have error status when given true error argument" do
        json = ApiResponse.json(error: true)
        assert_equal :error, json[:status]
    end

    test "should properly return provided messages argument" do
        messages = ["This is a message"]
        json = ApiResponse.json(messages: messages)
        assert_equal messages, json[:messages]
    end

    test "should properly return provided payload argument" do
        payload = @user.basic_details
        json = ApiResponse.json(payload: payload)
        assert_equal payload, json[:payload]
    end

    test "messages parameter should only accept arguments of type Array" do
        messages = "Hello"
        assert_raises(ArgumentError) do 
            ApiResponse.json(messages: messages)
        end
    end

    test "payload parameter should only accept arguments of type Hash" do
        payload = [@user.basic_details]
        assert_raises(ArgumentError) do 
            ApiResponse.json(payload: payload)
        end
    end
end