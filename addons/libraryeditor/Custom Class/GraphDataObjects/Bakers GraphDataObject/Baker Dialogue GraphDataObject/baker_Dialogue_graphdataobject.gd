extends BakerGraphDataObject
class_name BakerDialogueGraphDataObject

const START_DIALOGUE := 9
const DIALOGUE_NODE := 10
const END_DIALOGUE := 11
const DIALOGUE_CHOICE := 12

func bake_node(nodes : BigGraphNodeMakeInsts) -> void:
	print(nodes.type_node)
	match nodes.type_node:
		START_DIALOGUE:
			pass
		DIALOGUE_NODE:
			pass
		END_DIALOGUE:
			pass
		DIALOGUE_CHOICE:
			print("!")
		_:
			for left_port : FromToWith in save_graph[nodes][LEFT_PORTS_DATA_NAME]:
				AddFreePort(left_port)
			for right_port : FromToWith in save_graph[nodes][RIGHT_PORTS_DATA_NAME]:
				AddFreePort(right_port)
