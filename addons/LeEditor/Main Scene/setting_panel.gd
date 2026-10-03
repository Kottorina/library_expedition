extends PanelContainer

@export var close_open_but_ar : Array[Button]

func _ready() -> void:
	for but in close_open_but_ar:
		but.pressed.connect(open_close_ui) 

func open_close_ui() -> void:
	visible = !visible
