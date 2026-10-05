extends Node
class_name ReaderUi

@export var base_signal : Signal

func EmitBaseSignal(type : SignalConst.SignalType, unic_id : int, first_data : Variant = -1, second_data : Variant = -1):
	var cont := SignalDataContainer.new()
	cont.signal_type = type
	cont.first_data = first_data
	cont.second_data = second_data
	cont.id = unic_id
	base_signal.emit(cont)

var timer := Timer.new()
func start() -> void:
	add_child(timer)
	var base_signal_update = Callable(self, "BaseSignalUpdate")
	if base_signal_update.is_valid():
		base_signal.connect(base_signal_update)
	else:
		push_warning("BaseSignalUpdate does not exist")
	
	var ready_second = Callable(self, "ReadySecond")
	if ready_second.is_valid():
		ready_second.call()
	else:
		push_warning("BaseSignalUpdate does not exist")
	
