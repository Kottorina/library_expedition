extends Resource
class_name DialogueStep

@export_enum("start_dialogue","make_dialogue","make_choise","end_dialogue","choise_dialogue"
) var step_type : int 
@export var step_data : Variant

@export var next_step_ar : Array[DialogueStep]
