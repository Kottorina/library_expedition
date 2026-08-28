extends Resource
class_name IdEnterToIdEnter ## Связь коннектора исходной комнаты с коннектором конечной комнаты, с указание конечной комнаты

@export var from_id : int
@export var to_id : int

@export var to_location : ReadyLocation ## Чекнуть на существование перед отрисовкой!
