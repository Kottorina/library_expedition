extends Node

@export var editor_save_data : EditorSaveData ## ДЛЯ СОХРАНЕНИЯ СОСТОЯНИЯ РЕДАКТОРА

@export var editor_obj_layers : Array[EditorObjectLayer] ## Для обработки разных данных 
@export var path_obj_layer : Array[PathNode] ## Для обработки зависимостей

@export_group("Managers")
@export var file_save_load : Node
@export var path_manager : Node

## БАЗОВЫЕ НАСТРОЙКИ
func _ready() -> void:
	file_save_load.edditor_save_data = editor_save_data
	path_manager.UpdateBaseUi(path_obj_layer)
