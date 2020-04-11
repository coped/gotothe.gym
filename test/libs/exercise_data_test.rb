require 'test_helper'

class ExerciseDataTest < ActiveSupport::TestCase
    def setup
        @exercises = ExerciseData.parse
    end

    test "parse should return an array" do
        assert_equal Array, @exercises.class
    end

    test "parsed array should only consist of hashes" do
        @exercises.each do |item|
            assert_equal Hash, item.class
        end
    end

    test "each hash in parse array should have all valid attributes" do
        valid_attributes = %w(
            id        name  title 
            primer    type  equipment 
            secondary steps tips
        )

        @exercises.each do |exercise|
            exercise_attributes = exercise.keys
            valid_attributes.each do |attribute|
                assert_includes exercise_attributes, attribute
            end
        end
    end
    
    test "parsing should return 288 exercises" do
        assert_equal 288, @exercises.count
    end

    test "seed should return true if successful" do
        assert_equal true, ExerciseData.seed(exercises: @exercises)
    end

    test "seed should return nil if something goes wrong" do
        assert_nil ExerciseData.seed(exercises: ["invalid data"])
    end

    test "should seed database with Exercise entries" do
        assert_difference -> { Exercise.count }, 288 do
            ExerciseData.seed(exercises: @exercises)
        end
    end

    test "should seed database with MuscleGroup entries" do
        assert_difference -> { MuscleGroup.count }, 14 do
            ExerciseData.seed(exercises: @exercises)
        end
    end

    test "Exercise and MuscleGroup entries should be properly associated" do
        ExerciseData.seed(exercises: @exercises)
        MuscleGroup.all.each do |muscle_group|
            muscle_group_exercises = @exercises.filter do |exercise| 
                exercise["primary"].include?(muscle_group.name)
            end
            
            muscle_group_exercises.each do |exercise|
                exercise_entry = Exercise.find_by(name: exercise["name"])

                assert_includes exercise_entry.muscle_groups, muscle_group
                assert_includes muscle_group.exercises, exercise_entry
            end
        end
    end
end