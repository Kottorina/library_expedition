extends Control

@export var gener_rule_editor: Control 

@export var node_list: MenuButton 

var un_id = 0
func get_id() -> int:
	un_id += 1
	return un_id

func _ready() -> void:
	start_bake_ui()

var main_popup : PopupMenu
func start_bake_ui() -> void:
	main_popup = node_list.get_popup()
	
	main_popup.clear()
	
	name_to_ind_dict.clear()
	ind_to_popup_dict.clear()
	id_to_big_graph_make_instr_dict.clear()
	
	main_popup.id_pressed.connect(graph_item_selected)

var name_to_ind_dict : Dictionary ## Name - Ind
var ind_to_popup_dict : Dictionary ## ind - PopupMenu

func add_new_item( name_group : String, item_instr : BigGraphNodeMakeInsts ) -> void:
	
	if ! name_to_ind_dict.has(name_group):
		var new_popup := PopupMenu.new()
		main_popup.add_submenu_node_item(name_group,new_popup)
		new_popup.id_pressed.connect(graph_item_selected)
		
		name_to_ind_dict[name_group] = main_popup.item_count-1
		ind_to_popup_dict[main_popup.item_count-1] = new_popup
	
	var cur_popup : PopupMenu = ind_to_popup_dict[name_to_ind_dict[name_group]]
	var id = get_id()
	cur_popup.add_item(item_instr.title_node,id)
	id_to_big_graph_make_instr_dict[id] = item_instr

var id_to_big_graph_make_instr_dict : Dictionary ## Id - BigGraphMakeNodeInstr

func graph_item_selected(id : int) -> void:
	if id_to_big_graph_make_instr_dict.has(id):
		
		gener_rule_editor.make_node_from_biginstr(id_to_big_graph_make_instr_dict[id])
