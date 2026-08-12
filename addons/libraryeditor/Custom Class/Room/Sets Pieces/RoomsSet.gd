@tool
extends Resource
class_name RoomsSet

@export var rooms_ar : Array[Room]

@export_group("tool")
@export var cell_to_rooms : Vector2i 
@export var room_size : Vector2i 
