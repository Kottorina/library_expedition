extends GraphEdit

@export var del_but : Button
@export var copy_but : Button

@export var load_graph : Node

func _ready() -> void:
	del_but.pressed.connect(on_del_node_pressed)
	copy_but.pressed.connect(CopyButPressed)

func on_del_node_pressed() -> void:
	if selected_node != null:
		selected_node.queue_free()

const CooorCopuPlus := Vector2(-100,-100) 

func CopyButPressed() -> void:
	if selected_node != null:
		var big_inst : BigGraphNodeMakeInsts = selected_node.get_meta(GraphNodeConstants.BIG_INSTR_NODE_DATA_NAME).duplicate(true)
		var new_node = load_graph.MakeNodeFromBigInstr(big_inst)
		new_node.position_offset = CooorCopuPlus + selected_node.position_offset
		set_selected(new_node)
		_on_node_selected(new_node)

func _on_connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	if is_node_connected(from_node, from_port, to_node, to_port):
		disconnect_node(from_node, from_port, to_node, to_port)
	else:
		connect_node(from_node, from_port, to_node, to_port)

var selected_node : GraphNode
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
