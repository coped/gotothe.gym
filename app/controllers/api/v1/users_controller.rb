module Api::V1
    class UsersController < ApplicationController
        skip_before_action :is_authorized?, only: [:create]
        before_action :is_current_user?, except: [:create]

        def show
            user_details = UserBlueprint.render_as_hash(@user)
            render json: {
                status: "success",
                messages: {},
                response: {
                    user: user_details
                }
            }
        end

        def create
            @user = User.new(user_params)
            if @user.save
                token = JsonWebToken.encode({ user_id: @user.id })
                user_details = UserBlueprint.render_as_hash(@user)
                render json: {
                    status: "success",
                    messages: {},
                    response: {
                        user: user_details,
                        jwt: token
                    }
                }
            else
                render json: {
                    status: "error",
                    messages: {
                        errors: @user.errors.messages,
                        error_message: @user.errors.full_messages.to_sentence
                    },
                    response: {}
                }
            end
        end

        def update
            if @user.update(user_params)
                user_details = UserBlueprint.render_as_hash(@user)
                render json: {
                    status: "success",
                    messages: {},
                    response: {
                        user: user_details
                    }
                }
            else
                render json: {
                    status: "error",
                    messages: {
                        errors: @user.errors.messages,
                        error_message: @user.errors.full_messages.to_sentence
                    },
                    response: {}
                }
            end
        end

        def destroy
            if @user.destroy
                render json: {
                    status: "success",
                    messages: {},
                    response: {}
                }
            else
                render json: {
                    status: "error",
                    messages: {
                        error_message: "Something happened. Please try again."
                    },
                    response: {}
                }
            end
        end

        private

            def user_params
                params.require(:user).permit(:name, :email, :password, :password_confirmation)
            end

            def is_current_user?
                @user = User.find_by(id: params[:id])
                if @current_user != @user
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
end