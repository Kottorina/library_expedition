extends Control
class_name ReaderDialogueUiGraphDataObject

@export var all_data_save : SaveDataAllLibrary
@export var read_data : String = "Dialogue"

var dialogue_is_work : bool = false

const UI_SCENE = preload("res://addons/libraryeditor/Custom Class/GraphDataObjects/Reader GraphDataObject/Reader Dialogue/dialogue_ui.tscn")
var ui_scene_node : Control

@export var time_anim : float = 2

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	ui_scene_node = UI_SCENE.instantiate()
	
	#ui_scene_node.hide()
	add_child(ui_scene_node)
	
signal dialogue_end 

var reader : ReaderDialogueGraphDataObject

func start_dialogue(id_obj : int, dialogue_name : String) -> bool:
	
	if dialogue_is_work == true:
		return false
	dialogue_is_work = true
	
	var obj = all_data_save.GetObjectFromId(read_data,id_obj)
	
	reader = ReaderDialogueGraphDataObject.new()
	
	reader.make_line.connect(make_line)
	reader.make_choise.connect(make_choise)
	reader.read_end.connect(make_dialogue_end)
	
	if reader.start_read(obj,dialogue_name) == false:
		return false
	
	await ui_scene_node.open_anim(time_anim)
	reader.continue_read.emit()
	return true

@export var time_next_char_character : float = 0.1
@export var time_between_character_and_line : float = 0.5
@export var time_next_char_line : float = 0.1

func make_line( data_dialogue : DataDialogue, dialogue_step : DialogueStep) -> void:
	var timer := Timer.new()
	add_child(timer)
	
	var text_ : String
	ui_scene_node.clear_dialogue()
	
	text_ = ""
	timer.start(time_next_char_character)
	for char in tr(dialogue_step.character_data):
		await timer.timeout
		text_ += char
		ui_scene_node.character.text = text_
	
	timer.start(time_between_character_and_line)
	await timer.timeout
	
	timer.start(time_next_char_line)
	text_ = ""
	for char in tr(dialogue_step.dialogue_data):
		await timer.timeout
		text_ += char
		ui_scene_node.line.text = text_
	
	if data_dialogue.is_skiped == true:
		ui_scene_node.skip_button.show()
		await ui_scene_node.skip_button.pressed
		ui_scene_node.skip_button.hide()
		
		ui_scene_node.clear_dialogue()
		reader.continue_read.emit()
	else:
		timer.stop()
		timer.start(data_dialogue.extra_time)
		await timer.timeout
		
		ui_scene_node.clear_dialogue()
		reader.continue_read.emit()

func make_choise( data_dialogue : DataDialogue, dialogue_step : DialogueStep) -> void:
	
	var buttons : Array[Button]
	
	for step : DialogueStep in dialogue_step.next_step_ar:
		var button = ui_scene_node.add_choise(step.dialogue_data)
		buttons.append(button)
	
	for i in buttons.size():
		buttons[i].pressed.connect(_on_button_choise_pressed.bind(i))

func _on_button_choise_pressed(index: int):
	reader.continue_read.emit(index)

func make_dialogue_end() -> void:
	await ui_scene_node.close_anim(time_anim)
	dialogue_end.emit()
	dialogue_is_work = false
