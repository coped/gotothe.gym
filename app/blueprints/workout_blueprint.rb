class WorkoutBlueprint < Blueprinter::Base
    view :basic_details do
        identifier :id
        fields :date, :note, :exercises
    end
end