extends Node
class_name ReaderManager 

signal BaseSignal(value : SignalDataContainer)

enum ReaderType {DialogueReader,AudioReader}

@export var base_files : LeFileSystem
@export var import_data : LeFileSystem
@export_group("Reader Ui")
@export var all_reader_ui_ar : Array[ReaderUi]

var all_reader_data : Dictionary 

func _ready() -> void:
	
	all_reader_data = {
		ReaderType.DialogueReader : ReaderDialogueData.new(),
		ReaderType.AudioReader : ReaderAudioData.new()
		}
	
	BaseSignal.connect(BaseSignalUpdate)
	for reader in all_reader_ui_ar:
		reader.base_signal = BaseSignal
		reader.start()
	for reader_data : ReaderMain in all_reader_data.values():
		reader_data.base_signal = BaseSignal
		reader_data.current_data_ar = GetAlldatacontainerFromDataKey(
			reader_data.GetCurrentDataKey()
			)

func StartRead(type : ReaderType,name_res : String) -> void:
	
	var reader : ReaderMain
	
	reader = all_reader_data[type]
		
	reader.base_signal = BaseSignal
	print(reader.GetCurrentDataKey())
	await reader.ReadDataName(name_res)

func GetAlldatacontainerFromDataKey(data_key : String) -> Array[DataContainer]:
	
	var all_bake_data : Array[DataContainer]
	var all_library_obj_ar = base_files.GetArFromKey(data_key)
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
		
		SignalConst.SignalType.GetDataFromPathToData:
			
			var data_ar = import_data.GetObjectFromId(
				signal_cont.body_res.category,
				signal_cont.body_res.id
				)
			
			EmitBaseSignal(
				SignalConst.SignalType.TakeDataFromPathToPath,
				-1,
				data_ar.data[signal_cont.body_res.id_in_ar]
				)
		SignalConst.SignalType.StartDialogue:
			var reader : ReaderMain = all_reader_data[ReaderType.DialogueReader]
			reader.ReadDataName(signal_cont.body_res)
		SignalConst.SignalType.StartAudio:
			var reader : ReaderMain = all_reader_data[ReaderType.AudioReader]
			reader.ReadDataName(signal_cont.body_res)

func EmitBaseSignal(type_ : SignalConst.SignalType, body_res_ : Variant = -1, body_volue_ : Variant = -1):
	var cont := SignalDataContainer.new()
	cont.signal_type = type_
	cont.body_res = body_res_
	cont.body_value = body_volue_
	BaseSignal.emit(cont)
