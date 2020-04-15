require 'test_helper'

class Api::ExercisesControllerTest < ActionDispatch::IntegrationTest
    def setup
        @exercise = exercises(:example_exercise)
        muscle_groups = [MuscleGroup.create!(name: "deltoid"), MuscleGroup.create!(name: "bicep")]
        @exercise.muscle_groups << muscle_groups
    end

    test "should give all exercises" do
        get api_v1_exercises_path
        assert_equal Exercise.count, json_response['payload']['exercises'].count
    end

    test "should give a specific exercise" do
        get api_v1_exercise_path(@exercise)
        assert_equal @exercise.name, json_response['payload']['exercise']['name']
    end

    test "should give the correct muscle groups for an exercise" do
        get api_v1_exercise_path(@exercise)
        muscle_groups_in_response = json_response['payload']['exercise']['muscle_groups'].map do |muscle_group|
            MuscleGroup.find_by(name: muscle_group['name'])
        end
        actual_muscle_groups = @exercise.muscle_groups
        assert_equal actual_muscle_groups.sort, muscle_groups_in_response.sort
    end

end
