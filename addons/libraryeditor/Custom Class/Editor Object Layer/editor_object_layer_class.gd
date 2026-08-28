extends Resource
class_name EditorObjectLayer

@export var ui_name : String

@export var save_array_name : String
@export var object_script_path : String ## ПРИ СОЗДАНИИ НОВОГО В ЛИСТЕ, КОПИРАЕТЬСЯ С НЕГО, ПОТОМУ ЧТО instantiate НЕ РАБОТАТЕ С КАСТМОМ

@export var baker_prew : Resource ## Для Запекания

@export_group("Ui")
## ФЛАГИ ДЛЯ UI, ПРИ ЗАГРУЗКЕ
