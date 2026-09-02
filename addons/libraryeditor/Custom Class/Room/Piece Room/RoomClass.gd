extends Resource
class_name Room

@export var name_ : String = "" ##Имя при заходе в комнату и тд?
@export var id_ : int ##Id при сохранении, просто надо

@export var base_tile : Array[BaseTile]

@export var room_connectors_ar : Array[RoomConnector]
@export var room_enter_ar : Array[RoomEnter]

@export var min_max_coord : Vector4i ##Min (X,Y), Max (X,Y) Для выравнивания, так как фактичесски они все в общем пространстве (я сама хуй его знает как но оно работает)

@export var deco_istr_dict : Dictionary ## { deco_type (string) : [ base_tile ( для ui ), base_tile ( уже разновидност )... ]  }

func update_room_from_new_room(new_room : Room) -> void:
	name_ = new_room.name_
	base_tile = new_room.base_tile
	
	if room_connectors_ar.size() == new_room.room_connectors_ar.size():
		for id_con in room_connectors_ar.size():
			room_connectors_ar[id_con].update_room_connector_data(new_room.room_connectors_ar[id_con])
	if room_enter_ar.size() == new_room.room_enter_ar.size():
		for id_con in room_enter_ar.size():
			room_enter_ar[id_con].update_room_enter_data(new_room.room_enter_ar[id_con])

	min_max_coord = new_room.min_max_coord
	deco_istr_dict = new_room.deco_istr_dict
