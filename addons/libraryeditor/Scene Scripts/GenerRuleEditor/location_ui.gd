extends Control

@export var gener_rule_editor : Control ## Главный нод, из него подтигиваються, пути и рисуються ноды 

@export var type_item : OptionButton
@export var id_item : OptionButton

@export var item_name : TextEdit

@export var save_node : Node

@export var add_node_ui : Node 

func _ready() -> void:
	update_id_list()

func _on_load_button_pressed() -> void:
	var cur_id = id_item.get_selected_id()
	match type_item.selected:
		0:
			var ready_location_set : ReadyLocationSet = ResourceLoader.load(
				gener_rule_editor.ready_location_set_path,"",ResourceLoader.CACHE_MODE_IGNORE)
			var cur_ready_location = ready_location_set.get_ready_location_from_id(cur_id)
			if cur_ready_location != null:
				load_graph(cur_ready_location.save_graph)
				load_ui(cur_ready_location.ui)
		1:
			var big_ready_location_set : BigReadyLocationSet = ResourceLoader.load(
				gener_rule_editor.big_ready_location_set_path,"",ResourceLoader.CACHE_MODE_IGNORE)
			var cur_big_ready_location = big_ready_location_set.get_big_ready_location_from_id(cur_id)
			if cur_big_ready_location != null:
				load_graph(cur_big_ready_location.save_graph)
				load_ui(cur_big_ready_location.ui)

func _on_save_button_pressed() -> void:
	save_graph()

func _on_add_new_button_pressed() -> void:
	match type_item.selected:
		0:
			var ready_location_set : ReadyLocationSet = ResourceLoader.load(
				gener_rule_editor.ready_location_set_path,"",ResourceLoader.CACHE_MODE_IGNORE)
			var new_ready_location = ready_location_set.add_new_ready_location()
			
			ResourceSaver.save(ready_location_set, gener_rule_editor.ready_location_set_path) 
			
			update_id_list()
			
			if new_ready_location != null:
				load_graph(new_ready_location.save_graph)
				load_ui(new_ready_location.ui)
				item_name.text = new_ready_location.name_
		1:
			var big_ready_location_set : BigReadyLocationSet = ResourceLoader.load(
				gener_rule_editor.big_ready_location_set_path,"",ResourceLoader.CACHE_MODE_IGNORE)
			var cur_big_ready_location = big_ready_location_set.add_new_ready_location()
			
			ResourceSaver.save(big_ready_location_set, gener_rule_editor.big_ready_location_set_path) 
			
			update_id_list()
			
			if cur_big_ready_location != null:
				load_graph(cur_big_ready_location.save_graph)
				load_ui(cur_big_ready_location.ui)
				item_name.text = cur_big_ready_location.name_

func _on_del_item_pressed() -> void:
	var cur_id = id_item.get_selected_id()
	match type_item.selected:
		0:
			var ready_location_set : ReadyLocationSet = ResourceLoader.load(
				gener_rule_editor.ready_location_set_path,"",ResourceLoader.CACHE_MODE_IGNORE)
			ready_location_set.del_item_from_id(cur_id)
			
			ResourceSaver.save(ready_location_set, gener_rule_editor.ready_location_set_path) 
			update_id_list()
		1:
			var big_ready_location_set : BigReadyLocationSet = ResourceLoader.load(
				gener_rule_editor.big_ready_location_set_path,"",ResourceLoader.CACHE_MODE_IGNORE)
			big_ready_location_set.del_item_from_id(cur_id)
			
			ResourceSaver.save(big_ready_location_set, gener_rule_editor.big_ready_location_set_path) 
			update_id_list()

func load_graph(graph : Dictionary) -> void:
	print("load graph")
	gener_rule_editor.load_graph(graph)
func load_ui( scene_graph_ui : SceneGraphUi) -> void:
	gener_rule_editor.load_ui_set(scene_graph_ui)

func save_graph() -> void:
	print("save graph")
	
	var cur_id = id_item.get_selected_id()
	match type_item.selected:
		0:
			var ready_location_set : ReadyLocationSet = ResourceLoader.load(
				gener_rule_editor.ready_location_set_path,"",ResourceLoader.CACHE_MODE_IGNORE)
			var cur_ready_location = ready_location_set.get_ready_location_from_id(cur_id)
			if cur_ready_location != null:
				var save_ind = ready_location_set.ready_location_ar.find(cur_ready_location)
				
				ready_location_set.ready_location_ar[save_ind] = save_node.save_ready_location(
					cur_ready_location)
				
				ResourceSaver.save(ready_location_set, gener_rule_editor.ready_location_set_path) 
				
			
		1:
			var big_ready_location_set : BigReadyLocationSet = ResourceLoader.load(
				gener_rule_editor.big_ready_location_set_path,"",ResourceLoader.CACHE_MODE_IGNORE)
			var cur_big_ready_location = big_ready_location_set.get_big_ready_location_from_id(cur_id)
			if cur_big_ready_location != null:
				var save_ind = big_ready_location_set.big_ready_location_ar.find(cur_big_ready_location)
				
				big_ready_location_set.big_ready_location_ar[save_ind] = save_node.save_big_ready_location(
					cur_big_ready_location)
				
				ResourceSaver.save(big_ready_location_set, gener_rule_editor.big_ready_location_set_path) 
				
			

## ПРИ ИЗМЕНЕНИИ ТЕКУЩЕГО ТИПА ПРЕДМЕТА 
func _on_type_item_item_selected(index: int) -> void:
	add_node_ui.update_ui()
	update_id_list()

func update_id_list() -> void:
	id_item.clear()
	match type_item.selected:
		0:
			var ready_location_set : ReadyLocationSet = ResourceLoader.load(
				gener_rule_editor.ready_location_set_path,"",ResourceLoader.CACHE_MODE_IGNORE)
			for loc in ready_location_set.ready_location_ar:
				var name_loc = str(loc.name_," ",loc.id_)
				id_item.add_item(name_loc,loc.id_)
		1:
			var big_ready_location_set : BigReadyLocationSet = ResourceLoader.load(
				gener_rule_editor.big_ready_location_set_path,"",ResourceLoader.CACHE_MODE_IGNORE)
			for loc in big_ready_location_set.big_ready_location_ar:
				var name_loc = str(loc.name_," ",loc.id_)
				id_item.add_item(name_loc,loc.id_)
	
	if id_item.item_count == 0:
		_on_add_new_button_pressed()

#@onready var gener_rule_editor: Control = $"../../../.."
#
#@export var save_graph_node : Node
#
#@export var auto_save: CheckBox 
#
#@export var location_list: OptionButton
#@export var location_name: TextEdit 
#
#var current_ready_locations_set : ReadyLocationSet
#
#func _ready() -> void:
	#
	#await get_tree().process_frame
	#
	#load_f()
#
#func _on_load_pressed() -> void:
	#load_f()
#
#func load_f() -> void:
	#var locations_path = gener_rule_editor.ready_location_set_path
	#var ready_locations = ResourceLoader.load(locations_path,"",ResourceLoader.CACHE_MODE_IGNORE)
	#current_ready_locations_set = ready_locations.duplicate()
	#
	#bake_ui()
	#if current_ready_locations_set.ready_location_ar.size() == 0:
		#_on_new_location_pressed()
	#else:
		#var id_selected = location_list.selected
		#load_ready_location_edit(location_list.get_item_metadata(id_selected))
	#
#
#func bake_ui() -> void:
	#var id_selected = location_list.selected
	#if id_selected == -1:
		#id_selected = 0
	#
	#var free_id = 0
	#location_list.clear()
	#for ready_location in current_ready_locations_set.ready_location_ar:
		#location_list.add_item(ready_location.name_,free_id)
		#location_list.set_item_metadata(free_id,ready_location)
		#free_id += 1
	#
	#location_list.select(id_selected)
#
#func _on_save_pressed() -> void:
	#var locations_path = gener_rule_editor.ready_location_set_path
	#
	#var id_selected = location_list.selected
	#save_current_graph(id_selected)
	#
	#ResourceSaver.save(current_ready_locations_set, locations_path) 
#
#func _on_new_location_pressed() -> void:
	#var ready_location = ReadyLocation.new()
	#current_ready_locations_set.ready_location_ar.append(ready_location)
	#
	#bake_ui()
	#location_list.select(location_list.item_count-1) ##Выбрать последний
	#load_ready_location_edit(location_list.get_item_metadata(location_list.item_count-1))
#
#func _on_rename_pressed() -> void:
	#var ready_location : ReadyLocation = location_list.get_selected_metadata()
	#ready_location.name_ = location_name.text
	#bake_ui()
#
#func _on_del_pressed() -> void:
	#var curent_ready_room = location_list.get_selected_metadata() 
	#current_ready_locations_set.ready_location_ar.erase(curent_ready_room)
	#
	#if current_ready_locations_set.ready_location_ar.is_empty():
		#_on_new_location_pressed()
		#return
	#
	#bake_ui()
	#location_list.select(0)
	#load_ready_location_edit(location_list.get_item_metadata(0))
#
#func _on_location_list_item_selected(index: int) -> void:
	#load_ready_location_edit(location_list.get_item_metadata(index))
	#
#func load_ready_location_edit(ready_location : ReadyLocation) -> void:
	#
	#location_name.text = ready_location.name_
	#gener_rule_editor.load_graph(ready_location.save_graph)
#
#func save_current_graph( id_selected : int) -> void: ## Запекает Локацию, Позволяет Использовать / Загружать
	#var curenet_ready_loc = save_graph_node.bake_ready_location_f(current_ready_locations_set.ready_location_ar[id_selected])
	#current_ready_locations_set.ready_location_ar[id_selected] = curenet_ready_loc
	#
	### ПРОСТО ОБНОВЛЕНИЕ, НУЖНО ИНОГДА 
	#load_ready_location_edit(curenet_ready_loc)
	#
	#var locations_path = gener_rule_editor.ready_location_set_path
	#ResourceSaver.save(current_ready_locations_set, locations_path) 
	#
