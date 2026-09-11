extends Resource
class_name DataDialogue

@export var step_dialogue_ar : Array[DialogueStep] ## НАБОР ИНСТРУКЦИЙ ДЛЯ ВОСПРОИЗВЕДЕНИЯ

@export var dialogue_name : String

@export_group("skip")
@export var is_skiped : bool ## МОЖНО ЛИ ПРОПУСКАТЬ ДИАЛОГИ
@export var befor_time : bool 
@export var after_time : bool 
@export var char_time : bool 
