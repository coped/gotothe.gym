module ApiResponse
    def self.json(error: false, messages: nil, payload: nil)
        json = Hash.new
        json[:status] = (error) ? :error : :success
        json[:messages] = messages if messages
        json[:payload] = payload if payload
        enforce_types(json)
    end

    private

        def self.enforce_types(json)
            # Messages should always be of type Array
            if !json[:messages].kind_of?(Array) and !json[:messages].nil?
                raise ArgumentError, "JsonReponse messages argument should be of class Array"
            end
            # Payload should always be of type Hash
            if !json[:payload].kind_of?(Hash) and !json[:payload].nil?
                raise ArgumentError, "JsonResponse payload argument should be of class Hash"
            end
            return json
        end     
end
