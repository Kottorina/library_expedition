extends Node
class_name ConnectorToConnector ## Связь коннектора исходной комнаты с коннектором конечной комнаты, с указание конечной комнаты

@export var from_connector : RoomConnector
@export var to_connector : RoomConnector

@export var to_room : Room ## Чекнуть на существование перед отрисовкой!
