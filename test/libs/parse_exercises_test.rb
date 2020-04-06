require 'test_helper'

class ParseExercisesTest < ActiveSupport::TestCase
    def setup
        @exercises = ParseExercises.new
    end

    test "should return an array when called" do
        assert_equal Array, @exercises.call.class
    end

    test "returned array should only consist of hashes" do
        @exercises.call.each do |item|
            assert_equal Hash, item.class
        end
    end

    test "each hash should have all valid attributes" do
        valid_attributes = %w(
            id        name  title 
            primer    type  equipment 
            secondary steps tips
        )

        @exercises.call.each do |exercise|
            valid_attributes.each do |attribute|
                assert_includes exercise.keys, attribute
            end
        end
    end

    test "should return nil when something goes wrong" do
        invalid_exercises = ParseExercises.new(
            starting_directory: Rails.root.join('invalid', 'path')
        )
        assert_nil invalid_exercises.call
    end
    
    # Fails. Returns a count of 289
    test "should return 280 exercises when called" do
        assert_equal 280, @exercises.call.count
    end
end