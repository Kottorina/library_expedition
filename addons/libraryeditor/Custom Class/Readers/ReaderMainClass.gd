extends Resource
class_name ReaderMain

var data_key : String
@export var base_signal : Signal

func GetCurrentDataKey() -> String:
	var get_data_key = Callable(self, "GetDataKey")
	if get_data_key.is_valid():
		return get_data_key.call()
	return ""

var current_data_ar : Array[DataContainer]
func ReadDataArray(data_ar : Array[DataContainer],data_name_ : String) -> void:
	
	current_data_ar = data_ar
	
	var current_data_cont : DataContainer
	for data_cont in data_ar:
		if data_cont.data_name == data_name_:
			current_data_cont = data_cont
	if current_data_cont == null:
		push_warning("data_name_ does not exist")
		return
	
	var read_data = Callable(self, "ReadDataContainer")
	if read_data.is_valid():
		await read_data.call(current_data_cont) 
		return 
	else:
		push_warning("ReadDataContainer does not exist")
		return

func ReadNextDataName(data_name_ : String) -> bool:
	for data_cont in current_data_ar:
		if data_cont.data_name == data_name_:
			var read_data = Callable(self, "ReadDataContainer")
			read_data.call(data_cont) 
			return true
	return false

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
			if body_volue == -1:
				return cont.body_value
			if cont.body_value == body_volue:
				return cont.body_value
	return false
