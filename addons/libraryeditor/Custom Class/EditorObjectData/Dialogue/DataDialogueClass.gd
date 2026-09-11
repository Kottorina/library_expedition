extends Resource
class_name DataDialogue

@export var step_dialogue_ar : Array[DialogueStep] ## НАБОР ИНСТРУКЦИЙ ДЛЯ ВОСПРОИЗВЕДЕНИЯ

@export var dialogue_name : String

@export_group("skip")
@export var is_skiped : bool ## МОЖНО ЛИ ПРОПУСКАТЬ ДИАЛОГИ

@export var befor_time : float 
@export var after_time : float 

@export var between_character_line_time : float
@export var char_character_time : float 
@export var char_line_time : float
