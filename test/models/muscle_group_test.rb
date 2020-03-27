require 'test_helper'

class MuscleGroupTest < ActiveSupport::TestCase
  def setup
    @muscle_group = muscle_groups(:example_muscle_group)
  end

  test "muscle group is valid" do
    assert @muscle_group.valid?
  end

  test "muscle group name should always be present" do
    @muscle_group.name = "     "
    assert_not @muscle_group.valid?
  end

  test "muscle group length should not exceed maxumim string length of 255" do
    @muscle_group.name = "e" * 256
    assert_not @muscle_group.valid?
  end
end
