class JsonWebToken
    def self.encode(payload:, expiration: 24.hours.from_now)
        payload["expiration"] = expiration.to_i
        JWT.encode(payload, ENV['JWT_SECRET'])
    end

    def self.decode(token:)
        begin
            payload = JWT.decode(
                token, 
                ENV['JWT_SECRET'],
                true,
                algorithm: "HS256"
            ).first
            payload
        rescue JWT::DecodeError => e 
            nil
        end
    end
end