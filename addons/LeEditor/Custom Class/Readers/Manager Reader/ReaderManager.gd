extends Node
class_name ReaderManager 

signal BaseSignal(value : SignalDataContainer)

enum ReaderType {DialogueReader,AudioReader}

@export var AllSaveData : SaveDataAllLibrary
@export_group("Reader Ui")
@export var all_reader_ui_ar : Array[ReaderUi]

func _ready() -> void:
	BaseSignal.connect(BaseSignalUpdate)
	for reader in all_reader_ui_ar:
		reader.base_signal = BaseSignal
		reader.start()

func StartRead(type : ReaderType,name_res : String) -> void:
	
	var reader : ReaderMain
	
	match type:
		ReaderType.DialogueReader:
			reader = ReaderDialogueData.new()
		ReaderType.AudioReader:
			reader = ReaderAudioData.new()
		
	reader.base_signal = BaseSignal
	print(reader.GetCurrentDataKey())
	await reader.ReadDataArray(GetAlldatacontainerFromDataKey(
		reader.GetCurrentDataKey()),name_res
		)

func GetAlldatacontainerFromDataKey(data_key : String) -> Array[DataContainer]:
	
	var all_bake_data : Array[DataContainer]
	var all_library_obj_ar = AllSaveData.GetArFromKey(data_key)
	for obj in all_library_obj_ar:
		if obj is GraphDataObjects:
			for bake_container in obj.bake_data_ar:
				all_bake_data.append(bake_container)
	return all_bake_data

func BaseSignalUpdate(signal_cont : SignalDataContainer) -> void:
	await get_tree().process_frame
	match signal_cont.signal_type:
		SignalConst.SignalType.TimerMake:
			var timer := Timer.new()
			add_child(timer)
			if signal_cont.body_value > 0:
				timer.start(signal_cont.body_value)
				await timer.timeout
			EmitBaseSignal(SignalConst.SignalType.TimerTimeout,-1,signal_cont.body_res)
			timer.queue_free()

func EmitBaseSignal(type_ : SignalConst.SignalType, body_res_ : Variant = -1, body_volue_ : Variant = -1):
	var cont := SignalDataContainer.new()
	cont.signal_type = type_
	cont.body_res = body_res_
	cont.body_value = body_volue_
	BaseSignal.emit(cont)
