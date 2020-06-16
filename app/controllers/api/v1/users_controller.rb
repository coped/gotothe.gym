module Api::V1
    class UsersController < ApplicationController
        skip_before_action :require_authorization, only: [:create]
        before_action :is_current_user?, except: [:create]

        def show
            json = ApiResponse.json(
                payload: @user.details(with_jwt: true)
            )
            render json: json, status: :ok
        end

        def create
            @user = User.new(user_params)
            if @user.save
                json = ApiResponse.json(
                    payload: { 
                        jwt: @user.generate_jwt,
                        user: UserBlueprint.render_as_hash(@user)
                    }
                )
                render json: json, status: :ok
            else
                messages = [Messages.user_errors(@user)]
                json = ApiResponse.json(
                    error: true, 
                    messages: messages
                )
                render json: json, status: :unprocessable_entity
            end
        end

        def update
            if @user.update(user_params)
                json = ApiResponse.json(
                    payload: @user.details
                )
                render json: json, status: :ok
            else
                messages = [Messages.user_errors(@user)]
                json = ApiResponse.json(
                    error: true,
                    messages: messages
                )
                render json: json, status: :unprocessable_entity
            end
        end

        def destroy
            if @user.destroy
                render json: ApiResponse.json
            else
                messages = [Messages.destroy_error]
                json = ApiResponse.json(
                    error: true,
                    messages: messages
                )
                render json: json, status: :unprocessable_entity
            end
        end

        private

            def user_params
                params.require(:user).permit(:name, :email, :password, :password_confirmation)
            end

            def is_current_user?
                if @current_user.id != params[:id].to_i
                    messages = [Messages.unauthorized]
                    json = ApiResponse.json(
                        error: true,
                        messages: messages
                    )
                    return render json: json, status: :unauthorized
                else
                    @user = @current_user
                end
            end
    end
end