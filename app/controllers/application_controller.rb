class ApplicationController < ActionController::API
    before_action :is_authorized?

    private

        def authorize_request
            @current_user = (AuthorizeApiRequest.new(headers: request.headers).call)
        end

        def is_authorized?
            if !authorize_request
                messages = ["You're not authorized to view that page."]
                json = JsonResponse.new(error: true, messages: messages)
                render json: json.response, status: :unauthorized
            end
        end
end
