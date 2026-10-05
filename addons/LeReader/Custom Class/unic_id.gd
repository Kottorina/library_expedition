extends Resource
class_name UnicId

var unic_id : int = 0
func GetUnicId() -> int:
	unic_id += 1
	return unic_id
