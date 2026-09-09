extends Resource
class_name EditorObjectLayer

@export var data_key : String

@export var baker_object_script_path : Script ## Для Запекания

@export_group("Ui")
## ФЛАГИ ДЛЯ UI, ПРИ ЗАГРУЗКЕ

@export var ui_start_gener_node : bool = true
@export var ui_start_gener_empty_node : bool = false
@export var ui_all_rnd_fork : bool = false
@export var ui_custom_big_instr : bool = false ## А ОНО НАМ ВООБЩЕ БЛЯДЬ НАДО В ЭТОМ ВИДЕ?
@export var ui_connectors_plugs : bool = false
@export var ui_enter_node : bool = false
## ПОКА ВОПРОС ПО НЕОБХОДИМОСТИ И ОФОРМЛЕНИЮ
@export var ui_rooms_nodes : bool = false
## МОЖЕТ ВЫЗВАТЬ ОБЬЕКТЫ ИЗ EDITORLAYER В ВИДЕ UI
@export var ui_editor_layer_nodes : String = ""

@export var ui_dialogue_start : bool = false
@export var ui_dialogue_node : bool = false
@export var ui_dialogue_end : bool = false

@export var ui_dialogue_choice_2 : bool = false
@export var ui_dialogue_choice_3 : bool = false
@export var ui_dialogue_choice_4 : bool = false

@export var ui_crossroad_2 : bool = false
@export var ui_crossroad_4 : bool = false
@export var ui_crossroad_6 : bool = false
