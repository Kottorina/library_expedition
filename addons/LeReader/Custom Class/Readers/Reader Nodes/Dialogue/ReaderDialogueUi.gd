extends ReaderUi
class_name ReaderDialogueUi

const UI_SCENE = preload("uid://dr8ljoyoema8a")
var ui_scene_node : Control
func ReadySecond() -> void:
	
	ui_scene_node = UI_SCENE.instantiate()
	add_child(ui_scene_node)

func BaseSignalUpdate(signal_cont : SignalDataContainer) -> void:
	match signal_cont.signal_type:
		SignalConst.SignalType.DialogueOpenAnim:
			
			await ui_scene_node.open_anim()
			EmitBaseSignal(SignalConst.SignalType.DialogueContinue,signal_cont.id)
			
		SignalConst.SignalType.DialogueCloseAnim:
			
			await ui_scene_node.close_anim()
		
		SignalConst.SignalType.DialogueMakeLine:
			MakeLine(signal_cont.first_data,signal_cont.second_data,signal_cont.id)
		SignalConst.SignalType.DialogueMakeChoise:
			make_choise(signal_cont.first_data,signal_cont.second_data,signal_cont.id)

func MakeLine( data_dialogue : DataDialogue, dialogue_step : DialogueStep, signal_id : int) -> void:
	
	ui_scene_node.clear_dialogue()
	
	timer.start(data_dialogue.befor_time)
	await timer.timeout
	
	await write_step_by_step(ui_scene_node.character,dialogue_step.character_data,data_dialogue.char_character_time)
	
	timer.start(data_dialogue.between_character_line_time)
	await timer.timeout
	
	await write_step_by_step(ui_scene_node.line,dialogue_step.line_data,data_dialogue.char_line_time)
	
	timer.start(data_dialogue.after_time)
	await timer.timeout
	
	EmitBaseSignal(SignalConst.SignalType.DialogueContinuePreliminary,signal_id)
	
	if data_dialogue.is_skiped == true:
		ui_scene_node.skip_button.show()
		await ui_scene_node.skip_button.pressed
		ui_scene_node.skip_button.hide()
		
		EmitBaseSignal(SignalConst.SignalType.DialogueContinue,signal_id)
	else:
		timer.start(data_dialogue.after_time)
		await timer.timeout
		
		EmitBaseSignal(SignalConst.SignalType.DialogueContinue,signal_id)

signal write_step_by_step_complete 
func write_step_by_step(node : Control, write_text : String, time : float) -> bool:
	var cur_text = ""
	timer.start(time)
	for char in tr(write_text):
		await timer.timeout
		cur_text += char
		node.text = cur_text
	write_step_by_step_complete.emit()
	return true

func make_choise( data_dialogue : DataDialogue, dialogue_step : DialogueStep,signal_id : int) -> void:
	flag_make_choise_complete = false
	
	ui_scene_node.clear_dialogue()
	
	timer.start(data_dialogue.befor_time)
	await timer.timeout
	
	await write_step_by_step(ui_scene_node.character,dialogue_step.character_data,data_dialogue.char_character_time)
	
	timer.start(data_dialogue.between_character_line_time)
	await timer.timeout
	
	await write_step_by_step(ui_scene_node.line,dialogue_step.line_data,data_dialogue.char_line_time)
	
	timer.start(data_dialogue.after_time)
	await timer.timeout

	EmitBaseSignal(SignalConst.SignalType.DialogueContinuePreliminary,signal_id)
	
	var ind : int = 0
	for step : DialogueStep in dialogue_step.next_step_ar:
		
		if flag_make_choise_complete == true:
			break
		
		var button : Button = ui_scene_node.add_choise()
		button.disabled = true
		
		await write_step_by_step(button,step.line_data,data_dialogue.char_line_time)

		button.pressed.connect(_on_button_choise_pressed.bind(ind))
		
		button.disabled = false
		
		ind += 1
	flag_make_choise_complete = true

var flag_make_choise_complete : bool = false

func _on_button_choise_pressed(index: int):
	if flag_make_choise_complete == true:
		EmitBaseSignal(SignalConst.SignalType.DialogueContinue,-1,index)
		return
	await write_step_by_step_complete
	flag_make_choise_complete = true
	EmitBaseSignal(SignalConst.SignalType.DialogueContinue,-1,index)
