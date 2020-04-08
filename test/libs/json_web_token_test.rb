require 'test_helper'

class JsonWebTokenTest < ActiveSupport::TestCase
    def setup
        @payload = HashWithIndifferentAccess.new({ user_id: 1 })
        @token = JsonWebToken.encode(payload: @payload)
        @decoded_token = JsonWebToken.decode(token: @token)
    end

    test 'should decode token to correct payload' do
        assert_equal @payload.first, @decoded_token.first
    end

    test 'should return an indifferent hash' do
        assert_equal @decoded_token['user_id'], @decoded_token[:user_id]
    end

    test 'encoding should append expiration key to payload with a value of 24 hours from now' do
        assert_includes @decoded_token, :expiration
        assert_equal 24.hours.from_now.to_i, @decoded_token[:expiration]
    end

    test 'should return nil if DecodeError is raised' do
        assert_nil JsonWebToken.decode(token: 'invalid token')
    end
end