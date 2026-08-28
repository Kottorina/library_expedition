extends Resource
class_name EditorObjectLayer

@export var ui_name : String

@export var save_array_name : String
@export var object_script_path : String ## ПРИ СОЗДАНИИ НОВОГО В ЛИСТЕ, КОПИРАЕТЬСЯ С НЕГО, ПОТОМУ ЧТО instantiate НЕ РАБОТАТЕ С КАСТМОМ

@export var baker_script_path : String ## Для Запекания

@export_group("Ui")
## ФЛАГИ ДЛЯ UI, ПРИ ЗАГРУЗКЕ

@export var ui_start_gener_node : bool = true
@export var ui_all_rnd_fork : bool = false
@export var ui_custom_big_instr : bool = false ## А ОНО НАМ ВООБЩЕ БЛЯДЬ НАДО В ЭТОМ ВИДЕ?
@export var ui_connectors_plugs : bool = false
@export var ui_enter_node : bool = false
@export var ui_rooms_nodes : bool = false
@export var ui_ready_location_nodes : bool = false
