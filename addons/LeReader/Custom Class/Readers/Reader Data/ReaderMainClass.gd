extends Resource
class_name ReaderMain

var flag_is_first_read : bool = true
var data_key : String
@export var base_signal : Signal

func GetCurrentDataKey() -> String:
	var get_data_key = Callable(self, "GetDataKey")
	if get_data_key.is_valid():
		return get_data_key.call()
	return ""

var current_data_ar : Array[DataContainer]
func ReadDataName(data_name_ : String, unic_code : int = UnicId.NullValue) -> bool:
	for data_cont in current_data_ar:
		if data_cont.data_name == data_name_:
			var read_data = Callable(self, "ReadDataContainer")
			read_data.call(data_cont, unic_code) 
			return true
	return false

var unic_id_obj : UnicId
func EmitBaseSignal(type : SignalConst.SignalType, first_data : Variant = null, second_data : Variant = null, custom_unic_id : int = UnicId.NullValue) -> int:
	var cont := SignalDataContainer.new()
	cont.signal_type = type
	cont.first_data = first_data
	cont.second_data = second_data
	var unic_id : int 
	if custom_unic_id == UnicId.NullValue:
		unic_id = unic_id_obj.GetUnicId()
	else:
		unic_id = custom_unic_id
	cont.id = unic_id
	base_signal.emit(cont)
	return unic_id
## ДОБАВИТЬ МАКСИМАЛЬНОЕ ВРЕМЯ ПРИ НИОБХОДИМОСТИ
func AwaintBaseSignal(type : SignalConst.SignalType,unic_id : int) -> Variant:
	while true:
		var cont : SignalDataContainer = await base_signal
		if cont.signal_type == type:
			if cont.id == unic_id:
				return cont.first_data
	return null
