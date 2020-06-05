class ExerciseBlueprint < Blueprinter::Base
    identifier :id
    fields :name, :title 
    
    view :all_details do
        association :muscle_groups, blueprint: MuscleGroupBlueprint
        fields :image_id, :primer, :movement_type, :equipment, 
               :secondary_muscle_groups, :steps, :tips
    end
end