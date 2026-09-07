extends GraphEdit

@export var del_button : Button
func _ready() -> void:
	del_button.pressed.connect(on_del_node_pressed)

func on_del_node_pressed() -> void:
	if selected_node != null:
		selected_node.queue_free()

func _on_connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	if is_node_connected(from_node, from_port, to_node, to_port):
		disconnect_node(from_node, from_port, to_node, to_port)
	else:
		connect_node(from_node, from_port, to_node, to_port)

var selected_node : Node
@warning_ignore("unused_parameter")
func _on_node_deselected(node: Node) -> void:
	selected_node = null
func _on_node_selected(node: Node) -> void:
	selected_node = node

func ClearGraphScene() -> void:
	## ОЧИСТИТЬ НАСТРОЙКИ ЕСЛИ ДОБАВЛЮ, ебала я вас всех
	clear_connections()
	for child in get_children():
		if child is GraphNode:
			child.queue_free()
