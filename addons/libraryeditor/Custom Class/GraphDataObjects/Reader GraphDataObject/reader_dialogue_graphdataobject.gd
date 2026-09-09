extends Node
class_name ReaderDialogueGraphDataObject

signal load_new_part( part : String )
signal load_complete

var rnd : RandomNumberGenerator

#func start_load(ready_location : GraphDataObjects, seed : int = 0) -> void:
	#
