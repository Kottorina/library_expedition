extends Resource
class_name ReaderMain

var data_key : String

func GetCurrentDataKey() -> String:
	var get_data_key = Callable(self, "GetDataKey")
	if get_data_key.is_valid():
		return get_data_key.call()
	return ""

func ReadDataArray(data_ar : Array[DataContainer],data_name_ : String) -> void:
	
	for data_cont in data_ar:
		if data_cont.data_name == data_name_:
			var read_data = Callable(self, "ReadDataContainer")
			if read_data.is_valid():
				return read_data.call(data_cont) 

func OpenAnim() -> void:
	pass
func CloseAnim() -> void:
	pass
func BaseSignal(data : Variant) -> Variant:
	return data
