extends Control

@onready var gener_rule_editor: Control = $"../../../.."

@export var auto_save: CheckBox 

@export var location_list: OptionButton
@export var location_name: TextEdit 

var current_ready_locations_set : ReadyLocationSet

func _ready() -> void:
	
	await get_tree().process_frame
	
	load_f()

func _on_load_pressed() -> void:
	load_f()

func load_f() -> void:
	var locations_path = gener_rule_editor.ready_location_set_path
	var ready_locations = ResourceLoader.load(locations_path,"",ResourceLoader.CACHE_MODE_IGNORE)
	current_ready_locations_set = ready_locations.duplicate()
	
	bake_ui()
	if current_ready_locations_set.ready_location_ar.size() == 0:
		_on_new_location_pressed()
	else:
		load_ready_location_edit(location_list.get_item_metadata(0))
	

func bake_ui() -> void:
	var id_selected = location_list.selected
	if id_selected == -1:
		id_selected = 0
	
	var free_id = 0
	location_list.clear()
	for ready_location in current_ready_locations_set.ready_location_ar:
		location_list.add_item(ready_location.name_,free_id)
		location_list.set_item_metadata(free_id,ready_location)
		free_id += 1
	
	location_list.select(id_selected)

func _on_save_pressed() -> void:
	var locations_path = gener_rule_editor.ready_location_set_path
	
	var id_selected = location_list.selected
	save_current_graph(id_selected)
	
	ResourceSaver.save(current_ready_locations_set, locations_path) 

func _on_new_location_pressed() -> void:
	var ready_location = ReadyLocation.new()
	current_ready_locations_set.ready_location_ar.append(ready_location)
	
	bake_ui()
	location_list.select(location_list.item_count-1) ##Выбрать последний
	load_ready_location_edit(location_list.get_item_metadata(location_list.item_count-1))

func _on_rename_pressed() -> void:
	var ready_location : ReadyLocation = location_list.get_selected_metadata()
	ready_location.name_ = location_name.text
	bake_ui()

func _on_del_pressed() -> void:
	var curent_ready_room = location_list.get_selected_metadata() 
	
	current_ready_locations_set.ready_location_ar.erase(curent_ready_room)
	
	bake_ui()
	location_list.select(0)
	load_ready_location_edit(location_list.get_item_metadata(0))

func _on_location_list_item_selected(index: int) -> void:
	load_ready_location_edit(location_list.get_item_metadata(index))
	
func load_ready_location_edit(ready_location : ReadyLocation) -> void:
	
	location_name.text = ready_location.name_
	gener_rule_editor.load_graph(ready_location.graph)


func save_current_graph( id_selected : int) -> void: ## ДОСТАЕТ И СОХРАНЯЕТ ГРАФ ТЕКУЩЕЙ СЦЕНЫ
	current_ready_locations_set.ready_location_ar[id_selected].graph = gener_rule_editor.get_current_graph()
