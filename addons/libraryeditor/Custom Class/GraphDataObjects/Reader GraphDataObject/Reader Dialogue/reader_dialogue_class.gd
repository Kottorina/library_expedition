extends Node
class_name ReaderDialogueGraphDataObject

signal load_new_part( part : String )
signal load_complete

var rnd : RandomNumberGenerator

var data_dialogue : DataDialogue ## Array[DialogueStep]

const BASE_SEED = 0
const DIALOGUE_SET : String = "dialogue_set"

signal make_line
signal make_choise

signal continue_read ## МОЖНО ЛИ ЧИТАТЬ ДАЛЬШЕ, И КАКОЙ ИЗ ВАРИАНТОВ ЧИТАТЬ ДАЛЬШЕ
signal base_signal ## ДЛЯ ПЕРЕДАЧИ ЗНАЧНИЙ, НУЖНО ДЛЯ АНИМАЦИИ
signal read_end 

func start_read(dialogue_graph_data : GraphDataObjects, dialogue_name : String, seed : int = BASE_SEED) -> bool:
	
	var bake_data
	
	if seed == BASE_SEED: ## ЕСЛИ НЕ НУЖЕН rnd
		bake_data = dialogue_graph_data.bake_data
	else:
		var baker := BakerDialogueGraphDataObject.new()
		bake_data = baker.bake_data(dialogue_graph_data)
	
	if ! bake_data.has(DIALOGUE_SET):
		push_warning("DIALOGUE_SET does not exist")
		read_end.emit()
		return false
	if ! bake_data[DIALOGUE_SET].has(dialogue_name):
		push_warning("dialogue_name does not exist")
		read_end.emit()
		return false
	data_dialogue = bake_data[DIALOGUE_SET][dialogue_name] as DataDialogue
	read_dialogue_step(data_dialogue.step_dialogue_ar[0])
	return true

func read_dialogue_step( dialogue_step : DialogueStep) -> void:
	match dialogue_step.step_type:
		0:
			base_signal.emit("start_sdialogue")
			await continue_read
			read_dialogue_step(dialogue_step.next_step_ar[0])
		1:
			make_line.emit(data_dialogue, dialogue_step)
			await continue_read
			read_dialogue_step(dialogue_step.next_step_ar[0])
		2:
			make_choise.emit(data_dialogue, dialogue_step)
			var value  = await continue_read
			read_dialogue_step(dialogue_step.next_step_ar[value].next_step_ar[0])
		3:
			base_signal.emit(dialogue_step.signal_data)
			read_end.emit()
		4:
			push_warning("You should not see this message --- ReaderDialogueGraphDataObject")
		
	
	
