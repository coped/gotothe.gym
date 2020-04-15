module Api::V1
    class ExercisesController < ApplicationController
        skip_before_action :require_authorization

        def index
            json = ApiResponse.json(
                payload: Exercise.all_exercises
            )
            render json: json, status: :ok
        end

        def show
            @exercise = Exercise.find_by(name: params[:name])
            json = ApiResponse.json(
                payload: @exercise.full_details
            )
            render json: json, status: :ok
        end
    end
end
