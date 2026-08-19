extends Resource
class_name BigReadyLocationSet

@export var big_ready_location_ar : Array[BigReadyLocation] 

const MinId : int = 0
const MaxId : int = 100

func get_big_ready_location_from_id(id : int) -> BigReadyLocation:
	var find_loc_ar : Array[BigReadyLocation] = []
	for loc in big_ready_location_ar:
		if loc.id_ == id:
			find_loc_ar.append(loc)
	
	if find_loc_ar.size() == 1:
		return find_loc_ar[0]
	
	elif find_loc_ar.size() > 1:
		print("In ReadyLocationSet more Id them one")
		return null
	
	return null

func del_item_from_id(id : int) -> void:
	var find_loc_ar : Array[ReadyLocation] = []
	for loc in big_ready_location_ar:
		if loc.id_ == id:
			big_ready_location_ar.erase(loc)
			return

func add_new_ready_location() -> BigReadyLocation:
	var new_id : int
	for id in range(MinId,MaxId):
		if get_big_ready_location_from_id(id) == null:
			new_id = id
			break
	
	var new_ready_location := BigReadyLocation.new()
	new_ready_location.id_ = new_id
	
	big_ready_location_ar.append(new_ready_location)
	
	return new_ready_location
