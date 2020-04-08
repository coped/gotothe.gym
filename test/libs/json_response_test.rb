require 'test_helper'

class JsonResponseTest < ActiveSupport::TestCase
    def setup
        @user = users(:first_user)
    end
    test "should have proper defaults" do
        json = JsonResponse.new
        assert_equal :success, json.response[:status]
        assert_nil json.response[:messages]
        assert_nil json.response[:payload]
    end

    test "should have error status when given true error argument" do
        json = JsonResponse.new(error: true)
        assert_equal :error, json.response[:status]
    end

    test "should properly return provided messages argument" do
        messages = ["This is a message"]
        json = JsonResponse.new(messages: messages)
        assert_equal messages, json.response[:messages]
    end

    test "should properly return provided payload argument" do
        payload = @user.basic_details
        json = JsonResponse.new(payload: payload)
        assert_equal payload, json.response[:payload]
    end

    test "messages parameter should only accept arguments of type Array" do
        messages = "Hello"
        assert_raises(ArgumentError) do 
            JsonResponse.new(messages: messages)
        end
    end

    test "payload parameter should only accept arguments of type Hash" do
        payload = [@user.basic_details]
        assert_raises(ArgumentError) do 
            JsonResponse.new(payload: payload)
        end
    end
end