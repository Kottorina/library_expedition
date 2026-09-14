extends Node
class_name ReaderDialogueGraphDataObject

var rnd : RandomNumberGenerator

var data_dialogue : DataDialogue ## Array[DialogueStep]

const BASE_SEED = 0
const DIALOGUE_SET : String = "dialogue_set"

const START_DIALOGUE = "start_sdialogue"

signal make_line
signal make_choise

signal continue_preliminary ## ПРИ ОКОНЧАНИИ ПЕЧАТАНЬЯ РЕПЛИКИ ИЛИ ВЫБОРА

signal continue_read ## ПРИ ПОЛНОМ ПРОЧТЕНИИ СООБЩЕНИЯ И ПРИ ВЫБОРЕ ОДНОГО ИЗ ДИАЛОГОВ В ВЫБОРЕ

signal base_signal ## ДЛЯ ПЕРЕДАЧИ ЗНАЧЕНИЙ, ОТДАЕТ И ПРИНИМАЕТ ЗНАЧЕНИЯ

signal read_end ## ПРИ ЗАВЕРШЕНИИ ЧТЕНИЯ ДИАЛОГА, ИЗ ЗА ОШИБКИ ИЛИ КОНЦА ДИАЛОГА

var timer := Timer.new()
const MAX_TIME_FOR_AWAIT = 10
func _ready() -> void:
	add_child(timer)

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
			base_signal.emit(START_DIALOGUE)
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
		5: ## Emit Signal
			base_signal.emit(dialogue_step.signal_data)
			read_dialogue_step(dialogue_step.next_step_ar[0])
		6: ## Await Signal
			make_line.emit(data_dialogue, dialogue_step)
			await continue_preliminary
			
			timer.start(MAX_TIME_FOR_AWAIT)
			var cal = Callable(self,"emit_base_signal_with").bind(dialogue_step.signal_data)
			timer.timeout.connect(cal)
			while true:
				if await base_signal == dialogue_step.signal_data:
					break
			timer.timeout.disconnect(cal)
			
			read_dialogue_step(dialogue_step.next_step_ar[0])

func emit_base_signal_with(val : Variant) -> void:
	base_signal.emit(val)
