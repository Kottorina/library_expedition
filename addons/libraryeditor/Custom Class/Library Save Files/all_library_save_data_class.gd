extends Resource

## УНИВЕРСАЛЬНАЯ ЗАМЕНА ReadyLocationSet BigReadyLocationSet
class_name SaveDataAllLibrary

@export var big_ready_location_ar_ : Array[BigReadyLocation] 

@export var ready_location_set : Array[ReadyLocation] 

@export var room_set : RoomsSet


const MinId : int = 0
const MaxId : int = 100

func get_variant_from_id(name_ar : String, id : int) -> Variant:
	
	var find_ar = get(name_ar)
	if find_ar is not Array:
		return
	
	var find_loc_ar : Array[BigReadyLocation] = []
	for loc in find_ar:
		if loc != null:
			if loc.id_ == id:
				find_loc_ar.append(loc)
	
	if find_loc_ar.size() == 1:
		return find_loc_ar[0]
	
	elif find_loc_ar.size() > 1:
		print("In ReadyLocationSet more Id them one")
		return null
	
	return null

func del_item_from_id(name_ar : String,id : int) -> void:
	
	var find_ar = get(name_ar)
	if find_ar is not Array:
		return
	
	var find_loc_ar : Array[ReadyLocation] = []
	for loc in find_ar:
		if loc.id_ == id:
			find_ar.erase(loc)
			return

func add_new_ready_location(name_ar : String, name_obj_class : String) -> BigReadyLocation:
	
	var find_ar = get(name_ar)
	if find_ar is not Array:
		return
	
	var new_id : int
	for id in range(MinId,MaxId):
		if get_variant_from_id(name_ar,id) == null:
			new_id = id
			break
	
	var object = ClassDB.instantiate(name_obj_class)
	object.id_ = new_id ## ПРОСТО ПОВЕРЬ, У НЕГО ЕСТЬ id_, ЕСЛИ НЕТ ТО Я НА КОЛЕНЯХ ИЗВЕНЯТЬСЯ БУДУ
	
	find_ar.append(object)
	
	return object
