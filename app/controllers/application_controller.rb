class ApplicationController < ActionController::API
    before_action :require_authorization

    private

        def authorize_request
            @current_user = ApiRequest.new(request).authorize
        end

        def require_authorization
            if !authorize_request
                messages = [Messages.unauthorized]
                json = ApiResponse.json(error: true, messages: messages)
                return render json: json, status: :unauthorized
            end
        end
end
