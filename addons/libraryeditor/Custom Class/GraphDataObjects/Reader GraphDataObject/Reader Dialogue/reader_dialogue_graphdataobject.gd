extends Control
class_name ReaderDialogueGraphDataObject

signal load_new_part( part : String )
signal load_complete

var rnd : RandomNumberGenerator

@export var all_data_save : SaveDataAllLibrary
@export var read_data : String = "Dialogue"

func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)

func start_read(ready_location : GraphDataObjects, seed : int = 0) -> void:
	pass
