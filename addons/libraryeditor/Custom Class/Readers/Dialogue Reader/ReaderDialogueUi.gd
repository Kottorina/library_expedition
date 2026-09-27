extends Control
class_name ReaderDialogueUi

@export var base_signal : Signal

func EmitBaseSignal(type_ : SignalConst.SignalType, body_res_ : Variant = -1, body_volue_ : Variant = -1):
	var cont := SignalDataContainer.new()
	cont.signal_type = type_
	cont.body_res = body_res_
	cont.body_value = body_volue_
	base_signal.emit(cont)
## ДОБАВИТЬ МАКСИМАЛЬНОЕ ВРЕМЯ ПРИ НИОБХОДИМОСТИ
func AwaintBaseSignal(type : SignalConst.SignalType,body_volue : Variant = -1) -> Variant:
	while true:
		var cont : SignalDataContainer = await base_signal
		if cont.signal_type == type:
			if body_volue == -1 or cont.body_value == body_volue:
				return body_volue
	return false

const UI_SCENE = preload("uid://dr8ljoyoema8a")
var ui_scene_node : Control

var timer := Timer.new()
func _ready() -> void:
	add_child(timer)
	
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	ui_scene_node = UI_SCENE.instantiate()
	add_child(ui_scene_node)
	
	base_signal.connect(BaseSignalUpdate)

func BaseSignalUpdate(signal_cont : SignalDataContainer) -> void:
	match signal_cont.signal_type:
		SignalConst.SignalType.DialogueOpenAnim:
			
			await ui_scene_node.open_anim()
			EmitBaseSignal(SignalConst.SignalType.DialogueContinue)
			
		SignalConst.SignalType.DialogueCloseAnim:
			
			await ui_scene_node.close_anim()
		
		SignalConst.SignalType.DialogueMakeLine:
			MakeLine(signal_cont.body_res,signal_cont.body_value)
		SignalConst.SignalType.DialogueMakeChoise:
			make_choise(signal_cont.body_res,signal_cont.body_value)


	

	
	#ui_scene_node.hide()
	
	#
#signal dialogue_end 
#
#var reader : ReaderDialogueData
#
#func start_dialogue(id_obj : int, dialogue_name : String) -> bool:
	#
	#if dialogue_is_work == true:
		#return false
	#dialogue_is_work = true
	#
	#var obj = all_data_save.GetObjectFromId(read_data,id_obj)
	#
	#if reader:
		#reader.queue_free()
	#reader = ReaderDialogueData.new()
	#
	#reader.make_line.connect(make_line)
	#reader.make_choise.connect(make_choise)
	#reader.read_end.connect(make_dialogue_end)
	#
	#if reader.start_read(obj,dialogue_name) == false:
		#return false
	#
	#
	#reader.continue_read.emit()
	#return true
#
func MakeLine( data_dialogue : DataDialogue, dialogue_step : DialogueStep) -> void:
	
	ui_scene_node.clear_dialogue()
	
	timer.start(data_dialogue.befor_time)
	await timer.timeout
	
	await write_step_by_step(ui_scene_node.character,dialogue_step.character_data,data_dialogue.char_character_time)
	
	timer.start(data_dialogue.between_character_line_time)
	await timer.timeout
	
	await write_step_by_step(ui_scene_node.line,dialogue_step.line_data,data_dialogue.char_line_time)
	
	timer.start(data_dialogue.after_time)
	await timer.timeout
	
	EmitBaseSignal(SignalConst.SignalType.DialogueContinuePreliminary)
	
	if data_dialogue.is_skiped == true:
		ui_scene_node.skip_button.show()
		await ui_scene_node.skip_button.pressed
		ui_scene_node.skip_button.hide()
		
		EmitBaseSignal(SignalConst.SignalType.DialogueContinue)
	else:
		timer.start(data_dialogue.after_time)
		await timer.timeout
		
		EmitBaseSignal(SignalConst.SignalType.DialogueContinue)

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
	
	await write_step_by_step(ui_scene_node.line,dialogue_step.line_data,data_dialogue.char_line_time)
	
	timer.start(data_dialogue.after_time)
	await timer.timeout

	EmitBaseSignal(SignalConst.SignalType.DialogueContinuePreliminary)
	
	var buttons : Array[Button]
	for step : DialogueStep in dialogue_step.next_step_ar:
		var button = ui_scene_node.add_choise()
		buttons.append(button)
		
		await write_step_by_step(button,step.line_data,data_dialogue.char_line_time)
	for i in buttons.size():
		buttons[i].pressed.connect(_on_button_choise_pressed.bind(i))

func _on_button_choise_pressed(index: int):
	EmitBaseSignal(SignalConst.SignalType.DialogueContinue,-1,index)
