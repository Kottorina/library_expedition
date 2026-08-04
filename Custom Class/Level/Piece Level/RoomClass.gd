extends Resource
class_name Room

@export var name_ : String ##Имя при заходе в комнату и тд?
@export var id_ : int ##Id при сохранении, просто надо

@export var base_tile : Array[BaseTile]
@export var room_connectors_ar : Array[RoomConnector]

@export var min_max_coord : Vector4i ##Min (X,Y), Max (X,Y) Для выравнивания, так как фактичесски они все в общем пространстве (я сама хуй его знает как но оно работает)
