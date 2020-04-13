class ApplicationController < ActionController::API
    before_action :is_authorized?

    private

        def authorize_request
            @current_user = (AuthorizeApiRequest.new(headers: request.headers).call)
        end

        def is_authorized?
            if !authorize_request
                messages = [Messages.unauthorized]
                json = ApiResponse.json(error: true, messages: messages)
                return render json: json, status: :unauthorized
            end
        end
end
