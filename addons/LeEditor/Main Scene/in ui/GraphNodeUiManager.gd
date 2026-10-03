extends Control

@export var load_node: Node 
@export var node_list: MenuButton 

var un_id = 0
func get_id() -> int:
	un_id += 1
	return un_id

func _ready() -> void:
	StartBakeUi()

var main_popup : PopupMenu
func StartBakeUi() -> void:
	main_popup = node_list.get_popup()
	
	Clear()
	
	if not main_popup.id_pressed.is_connected(GraphItemSelected):
		main_popup.id_pressed.connect(GraphItemSelected)

func Clear() -> void:
	main_popup = node_list.get_popup()
	
	main_popup.clear()
	
	name_to_ind_dict.clear()
	ind_to_popup_dict.clear()
	id_to_big_graph_make_instr_dict.clear()

var name_to_ind_dict : Dictionary ## Name - Ind
var ind_to_popup_dict : Dictionary ## ind - PopupMenu

func AddNewUiItem( name_group : String, item_instr : BigGraphNodeMakeInsts ) -> void:
	
	if ! name_to_ind_dict.has(name_group):
		var new_popup := PopupMenu.new()
		main_popup.add_submenu_node_item(name_group,new_popup)
		new_popup.id_pressed.connect(GraphItemSelected)
		
		name_to_ind_dict[name_group] = main_popup.item_count-1
		ind_to_popup_dict[main_popup.item_count-1] = new_popup
	
	var cur_popup : PopupMenu = ind_to_popup_dict[name_to_ind_dict[name_group]]
	var id = get_id()
	cur_popup.add_item(item_instr.title_node,id)
	id_to_big_graph_make_instr_dict[id] = item_instr

var id_to_big_graph_make_instr_dict : Dictionary ## Id - BigGraphMakeNodeInstr

func GraphItemSelected(id : int) -> void:
	if id_to_big_graph_make_instr_dict.has(id):
		## ОЧЕНЬ ВАЖНО НЕ ТРОГАТЬ СТРОКУ, СУКИ
		var new_big_instr = id_to_big_graph_make_instr_dict[id].duplicate(true)
		
		load_node.MakeNodeFromBigInstr(new_big_instr)
