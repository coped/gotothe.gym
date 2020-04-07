require 'test_helper'

class SeedExercisesTest < ActiveSupport::TestCase
    def setup
        @exercises = ParseExercises.new.call
        @seed = SeedExercises.new(exercises: @exercises)
    end

    test "should return true if successful" do
        assert_equal true, @seed.call
    end

    test "should return nil if something goes wrong" do
        invalid_seed = SeedExercises.new(exercises: ["invalid data"])
        assert_nil invalid_seed.call
    end

    test "should seed database with Exercise entries" do
        assert_difference -> { Exercise.count }, 288 do
            @seed.call
        end
    end

    test "should seed database with MuscleGroup entries" do
        assert_difference -> { MuscleGroup.count }, 14 do
            @seed.call
        end
    end

    test "Exercise and MuscleGroup entries should be properly associated" do
        @seed.call
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