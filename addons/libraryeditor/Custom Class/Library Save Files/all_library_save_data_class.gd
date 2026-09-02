@tool
extends Resource

## УНИВЕРСАЛЬНАЯ ЗАМЕНА ReadyLocationSet BigReadyLocationSet
class_name SaveDataAllLibrary

@export var all_data : Dictionary ##  Хранит все данные { data_key : Array[GraphDataObjects] }

# @export var room_set : RoomsSet ПОДУМАЙ КАК И ЗАЧЕМ

func get_ar_from_key(data_key : String ) -> Array:
	
	if all_data.has(data_key):
		return all_data[data_key]
	else:
		all_data[data_key] = []
		return all_data[data_key]

const MinId : int = 0
const MaxId : int = 100

func get_object_from_id(data_key : String, id : int) -> Variant:
	
	var cur_ar = get_ar_from_key(data_key)
	
	var find_loc_ar : Array[Resource] = []
	for loc in cur_ar:
		if loc != null:
			if loc.id_ == id:
				find_loc_ar.append(loc)
	
	if find_loc_ar.size() == 1:
		return find_loc_ar[0]
	elif find_loc_ar.size() > 1 :
		push_warning("In SaveDataAllLibrary more Id them one")
		return null
	
	return null

func del_item_from_id(data_key : String,id : int) -> void:
	
	var cur_ar = get_ar_from_key(data_key)
	
	var find_loc_ar : Array[Resource] = []
	for loc in cur_ar:
		if loc.id_ == id:
			cur_ar.erase(loc)
			return

func add_new_obj_in_array(data_key : String) -> Resource:
	
	var cur_ar = get_ar_from_key(data_key)
	
	var new_id : int
	for id in range(MinId,MaxId):
		if get_object_from_id(data_key , id) == null:
			new_id = id
			break
	
	var object := GraphDataObjects.new()
	object.id_ = new_id ## ПРОСТО ПОВЕРЬ, У НЕГО ЕСТЬ id_, ЕСЛИ НЕТ ТО Я НА КОЛЕНЯХ ИЗВЕНЯТЬСЯ БУДУ
	
	cur_ar.append(object)

	return object
