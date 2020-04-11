require 'test_helper'

class ExerciseDataTest < ActiveSupport::TestCase
    def setup
        @data = ExerciseData.new
    end

    test "exercises should return an array" do
        assert_equal Array, @data.exercises.class
    end

    test "exercises array should only consist of hashes" do
        @data.exercises.each do |item|
            assert_equal Hash, item.class
        end
    end

    test "each hash in parse array should have all valid attributes" do
        valid_attributes = %w(
            id        name  title 
            primer    type  equipment 
            secondary steps tips
        )

        @data.exercises.each do |exercise|
            exercise_attributes = exercise.keys
            valid_attributes.each do |attribute|
                assert_includes exercise_attributes, attribute
            end
        end
    end
    
    test "parsing should return 288 exercises" do
        assert_equal 288, @data.exercises.count
    end

    test "seed should return true if successful" do
        assert_equal true, @data.seed
    end

    test "should seed database with Exercise entries" do
        assert_difference -> { Exercise.count }, 288 do
            @data.seed
        end
    end

    test "should seed database with MuscleGroup entries" do
        assert_difference -> { MuscleGroup.count }, 14 do
            @data.seed
        end
    end

    test "Exercise and MuscleGroup entries should be properly associated" do
        @data.seed
        MuscleGroup.all.each do |muscle_group|
            muscle_group_exercises = @data.exercises.filter do |exercise| 
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