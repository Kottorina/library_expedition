@tool
extends Resource

## УНИВЕРСАЛЬНАЯ ЗАМЕНА ReadyLocationSet BigReadyLocationSet
class_name SaveDataAllLibrary

@export var all_data : Dictionary ##  Хранит все данные { data_key : Array[GraphDataObjects] }

# @export var room_set : RoomsSet ПОДУМАЙ КАК И ЗАЧЕМ

func GetArFromKey(data_key : String ) -> Array[LibraryObject]:
	
	if all_data.has(data_key):
		return all_data[data_key] as Array[LibraryObject]
	else:
		all_data[data_key] = []
		return all_data[data_key] as Array[LibraryObject]

const MinId : int = 0
const MaxId : int = 10000

const ObjectIdNotFind : int = -1

func GetObjectFromId(data_key : String, id : int) -> Variant:
	
	var cur_ar = GetArFromKey(data_key)
	
	var find_loc_ar : Array[LibraryObject] = []
	for loc in cur_ar:
		if loc != null:
			if loc.id_ == id:
				find_loc_ar.append(loc)
	
	if find_loc_ar.size() == 1:
		return find_loc_ar[0]
	elif find_loc_ar.size() > 1 :
		push_warning("In SaveDataAllLibrary more Id them one")
		return -1
	#push_warning("Id Not Find")
	return ObjectIdNotFind

func DelItemFromId(data_key : String,id : int) -> void:
	
	var cur_ar = GetArFromKey(data_key)
	
	for loc in cur_ar:
		if loc.id_ == id:
			cur_ar.erase(loc)
			return

func AddNewObjInArray(data_key : String, object : Variant, object_id : int = -1) -> Variant:
	
	var cur_ar = GetArFromKey(data_key)
	
	if object_id != -1:
		var result = GetObjectFromId(data_key , object_id)
		if result is int:
			if result == ObjectIdNotFind:
				
				object.id_ = object_id
				cur_ar.append(object)
				
				return object
		return false

	
	var new_id : int
	for id in range(MinId,MaxId):
		var result = GetObjectFromId(data_key , id)
		if result is int:
			if result == ObjectIdNotFind:
				new_id = id
				break
	
	object.id_ = new_id ## ПРОСТО ПОВЕРЬ, У НЕГО ЕСТЬ id_, ЕСЛИ НЕТ ТО Я НА КОЛЕНЯХ ИЗВЕНЯТЬСЯ БУДУ
	cur_ar.append(object)

	return object

func ClearCategory(data_key : String) -> void:
	all_data.erase(data_key)
