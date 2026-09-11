extends Control
class_name ReaderDialogueUiGraphDataObject

@export var all_data_save : SaveDataAllLibrary
@export var read_data : String = "Dialogue"

var dialogue_is_work : bool = false

const UI_SCENE = preload("res://addons/libraryeditor/Custom Class/GraphDataObjects/Reader GraphDataObject/Reader Dialogue/dialogue_ui.tscn")
var ui_scene_node : Control

@export var time_anim : float = 2

var timer := Timer.new()
func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	ui_scene_node = UI_SCENE.instantiate()
	add_child(timer)
	
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

func make_line( data_dialogue : DataDialogue, dialogue_step : DialogueStep) -> void:

	ui_scene_node.clear_dialogue()
	
	timer.start(data_dialogue.befor_time)
	await timer.timeout
	
	await write_step_by_step(ui_scene_node.character,dialogue_step.character_data,data_dialogue.char_character_time)
	
	timer.start(data_dialogue.between_character_line_time)
	await timer.timeout
	
	await write_step_by_step(ui_scene_node.line,dialogue_step.dialogue_data,data_dialogue.char_line_time)
	
	if data_dialogue.is_skiped == true:
		ui_scene_node.skip_button.show()
		await ui_scene_node.skip_button.pressed
		ui_scene_node.skip_button.hide()
		
		ui_scene_node.clear_dialogue()
		reader.continue_read.emit()
	else:
		timer.start(data_dialogue.after_time)
		await timer.timeout
		
		ui_scene_node.clear_dialogue()
		reader.continue_read.emit()

func write_step_by_step(node : Control, write_text : String, time : float) -> bool:
	var cur_text = ""
	timer.start(time)
	for char in tr(write_text):
		await timer.timeout
		cur_text += char
		node.text = cur_text
	return true

func make_choise( data_dialogue : DataDialogue, dialogue_step : DialogueStep) -> void:
	
	ui_scene_node.clear_dialogue()
	
	timer.start(data_dialogue.befor_time)
	await timer.timeout
	
	await write_step_by_step(ui_scene_node.character,dialogue_step.character_data,data_dialogue.char_character_time)
	
	timer.start(data_dialogue.between_character_line_time)
	await timer.timeout
	
	await write_step_by_step(ui_scene_node.line,dialogue_step.dialogue_data,data_dialogue.char_line_time)
	
	timer.start(data_dialogue.after_time)
	await timer.timeout
	
	var buttons : Array[Button]
	
	for step : DialogueStep in dialogue_step.next_step_ar:
		var button = ui_scene_node.add_choise()
		buttons.append(button)
		
		await write_step_by_step(button,step.dialogue_data,data_dialogue.char_line_time)
	
	for i in buttons.size():
		buttons[i].pressed.connect(_on_button_choise_pressed.bind(i))

func _on_button_choise_pressed(index: int):
	reader.continue_read.emit(index)

func make_dialogue_end() -> void:
	await ui_scene_node.close_anim(time_anim)
	dialogue_end.emit()
	dialogue_is_work = false
