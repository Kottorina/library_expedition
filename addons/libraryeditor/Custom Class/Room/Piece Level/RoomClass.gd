extends Resource
class_name Room

@export var name_ : String = "" ##Имя при заходе в комнату и тд?
@export var id_ : int ##Id при сохранении, просто надо

@export var base_tile : Array[BaseTile]
@export var room_connectors_ar : Array[RoomConnector]
@export var room_enter_ar : Array[RoomEnter]

@export var min_max_coord : Vector4i ##Min (X,Y), Max (X,Y) Для выравнивания, так как фактичесски они все в общем пространстве (я сама хуй его знает как но оно работает)

@export var deco_istr_dict : Dictionary ## { deco_type (string) : [ base_tile ( для ui ), base_tile ( уже разновидност )... ]  }
