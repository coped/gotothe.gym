class ExerciseBlueprint < Blueprinter::Base
    view :basic_details do
        identifier :id
        fields :name, :title 
        association :muscle_groups, blueprint: MuscleGroupBlueprint
    end
    view :full_details do
        include_view :basic_details
        fields :image_id, :primer, :movement_type, :equipment, 
               :secondary_muscle_groups, :steps, :tips
    end
end