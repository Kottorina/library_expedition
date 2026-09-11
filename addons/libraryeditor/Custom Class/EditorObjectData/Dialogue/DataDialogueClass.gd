extends Resource
class_name DataDialogue

@export var step_dialogue_ar : Array[DialogueStep] ## НАБОР ИНСТРУКЦИЙ ДЛЯ ВОСПРОИЗВЕДЕНИЯ

@export var dialogue_name : String

@export_group("skip")
@export var is_skiped : bool ## МОЖНО ЛИ ПРОПУСКАТЬ ДИАЛОГИ
@export var extra_time : bool ## СКОЛЬКО БУДЕТ ВИСТЕЬ ДИАЛОГ ПОСЛЕ ПОСЛЕДНЕГО СИМВОЛА
