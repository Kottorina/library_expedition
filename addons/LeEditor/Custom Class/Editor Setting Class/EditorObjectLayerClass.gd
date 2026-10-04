extends Resource
class_name EditorObjectLayer

@export var data_key : String

@export var baker_object_script_path : Script ## Для Запекания

## ФЛАГИ ДЛЯ UI, ПРИ ЗАГРУЗКЕ
@export_group("Ui")

@export_subgroup("Base Tool")
@export var ui_start_gener_node : bool = true
@export var ui_start_gener_empty_node : bool = false
@export var ui_all_rnd_fork : bool = false
#@export var ui_custom_big_instr : bool = false ## А ОНО НАМ ВООБЩЕ БЛЯДЬ НАДО В ЭТОМ ВИДЕ?
@export var ui_connectors_plugs : bool = false
@export var ui_enter_node : bool = false
## ПОКА ВОПРОС ПО НЕОБХОДИМОСТИ И ОФОРМЛЕНИЮ
@export var ui_rooms_nodes : bool = false
## МОЖЕТ ВЫЗВАТЬ ОБЬЕКТЫ ИЗ EDITORLAYER В ВИДЕ UI
@export var ui_editor_layer_nodes : String = ""

@export var ui_crossroad_2 : bool = false
@export var ui_crossroad_4 : bool = false
@export var ui_crossroad_6 : bool = false

@export_subgroup("Dialogue")
@export var ui_dialogue_start : bool = false
@export var ui_dialogue_node : bool = false
@export var ui_dialogue_end : bool = false

@export var ui_dialogue_choice_2 : bool = false
@export var ui_dialogue_choice_3 : bool = false
@export var ui_dialogue_choice_4 : bool = false

@export var ui_dialogue_con_2 : bool = false
@export var ui_dialogue_con_4 : bool = false
@export var ui_dialogue_con_6 : bool = false
@export var ui_dialogue_setting : bool = false

@export var ui_dialogue_emit_signal : bool = false
@export var ui_dialogue_await_signal : bool = false

@export var ui_dialogue_next_dialogue : bool = false

@export_subgroup("Audio")
@export var ui_audio_start : bool = false
@export var ui_audio_timer : bool = false
@export var ui_audio_end : bool = false

@export var ui_audio_crossroad_2 : bool = false
@export var ui_audio_crossroad_4 : bool = false
@export var ui_audio_crossroad_6 : bool = false

@export var ui_audio_setting_loop : bool = false

@export_group("Unic Ar")
@export var ui_link_data_ar : Array[PathNode]
