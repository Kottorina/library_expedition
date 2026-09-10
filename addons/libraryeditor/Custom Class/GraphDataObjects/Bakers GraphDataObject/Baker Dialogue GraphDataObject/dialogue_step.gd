extends Resource
class_name DialogueStep

@export_enum("start_dialogue","make_dialogue","make_choise","end_dialogue","choise_dialogue"
) var step_type : int ## start_dialogue make_dialogue make_choise end_dialogue choise_dialogue

@export var character_data : Variant ## ДЛЯ ПЕРСОНАЖЕЙ И ОБЬЯВЛЕНИЕМ ВЫБОРОВ
@export var dialogue_data : Variant ## ДЛЯ ДИАЛОГОВ И ВАРИАНТОВ ВЫБОРОВ

@export var signal_data : Variant

@export var next_step_ar : Array[DialogueStep]
