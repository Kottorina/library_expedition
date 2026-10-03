extends Node

@export var editor_save_data : EditorSaveData ## ДЛЯ СОХРАНЕНИЯ СОСТОЯНИЯ РЕДАКТОРА

@export var editor_obj_layers : Array[EditorObjectLayer] ## Для обработки разных данных 
@export var path_obj_layer : Array[PathNode] ## Для обработки зависимостей

#@export var room_set_path : String ## ВРЕМЕННЫЙ СПОСОБ ПОДТЯГИВАТЬ КОМНАТЫ

@export var file_save_load : Node
