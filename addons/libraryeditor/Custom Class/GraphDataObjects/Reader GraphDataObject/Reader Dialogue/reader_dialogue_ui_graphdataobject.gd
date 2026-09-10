extends Control
class_name ReaderDialogueUiGraphDataObject

func _on_button_pressed() -> void:
	var id = 0
	var test_dial_name = "Dial1"
	
	start_dialogue(id,test_dial_name)


@export var all_data_save : SaveDataAllLibrary
@export var read_data : String = "Dialogue"


const UI_SCENE = preload("res://addons/libraryeditor/Custom Class/GraphDataObjects/Reader GraphDataObject/Reader Dialogue/dialogue_ui.tscn")
var ui_scene_node : Control

@export var time_anim : float = 2

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	ui_scene_node = UI_SCENE.instantiate()
	
	#ui_scene_node.hide()
	add_child(ui_scene_node)
	
signal dialogue_end 

func start_dialogue(id_obj : int, dialogue_name : String) -> void:
	
	var obj = all_data_save.GetObjectFromId(read_data,id_obj)
	
	var reader = ReaderDialogueGraphDataObject.new()
	
	reader.make_line.connect(make_line)
	
	reader.start_read(obj,dialogue_name)
	
	await ui_scene_node.open_anim(time_anim)
	
	reader.continue_read.emit()
	
	await reader.read_end
	await ui_scene_node.close_anim(time_anim)
	
	dialogue_end.emit()

func make_line( dialogue_step : DialogueStep) -> void:
	print(dialogue_step.character_data)
