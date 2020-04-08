class JsonResponse
    def initialize(messages: nil, payload: nil, error: false)
        @messages = messages
        @payload = payload
        @error = error
        enforce_types
        @json = Hash.new
    end

    def response
        build_json
    end

    private
        
        def build_json
            @json[:status] = (@error) ? :error : :success
            @json[:messages] = @messages if @messages
            @json[:payload] = @payload if @payload
            @json
        end

        def enforce_types
            # Messages should always be of type Array
            if !@messages.kind_of?(Array) and !@messages.nil?
                raise ArgumentError, "JsonReponse messages argument should be of type Array"
            end
            # Payload should always be of type Hash
            if !@payload.kind_of?(Hash) and !@payload.nil?
                raise ArgumentError, "JsonResponse payload argument should be of type Hash"
            end
        end     
end