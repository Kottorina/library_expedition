extends Node
class_name ReaderUi

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
			if body_volue is int:
				if body_volue == -1:
					return cont.body_value
			if cont.body_value == body_volue:
				return cont.body_value
	return false

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
	
