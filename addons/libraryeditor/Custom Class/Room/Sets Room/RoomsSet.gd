@tool
extends Resource
class_name RoomsSet

@export var rooms_ar : Array[Room]

@export_group("tool")
@export var cell_to_rooms : Vector2i 
@export var room_size : Vector2i 

@export var cell_to_deco_setting : Vector2i 
@export var deco_setting_size : Vector2i

@export_group("custom_deco")

@export var deco_istr_dict : Dictionary ## { deco_type (string) : [ base_tile ( для ui ), base_tile ( уже разновидност )... ]  }
