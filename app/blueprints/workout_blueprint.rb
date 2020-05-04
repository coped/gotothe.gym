class WorkoutBlueprint < Blueprinter::Base
    view :basic_details do
        identifier :id
        fields :date, :note
        association :exercises, blueprint: ExerciseBlueprint, view: :full_details
    end
end