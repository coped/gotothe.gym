class ApplicationController < ActionController::API
    before_action :is_authorized?

    private

        def authorize_request
            @current_user = (AuthorizeApiRequest.new(headers: request.headers).call)
        end

        def is_authorized?
            if !authorize_request
                render json: {
                    status: "error",
                    messages: {
                        error_message: "You're not authorized to view that page."
                    },
                    response: {}
                }
            end
        end
end
