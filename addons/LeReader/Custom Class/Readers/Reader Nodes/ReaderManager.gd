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
	var unic_id_obj := UnicId.new()
	for reader_data : ReaderMain in all_reader_data.values():
		reader_data.unic_id_obj = unic_id_obj
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
	print("New Signal: ",SignalConst.SignalType.keys()[signal_cont.signal_type],", From Id: ",signal_cont.id)
	await get_tree().process_frame
	match signal_cont.signal_type:
		SignalConst.SignalType.TimerMake:
			var timer := Timer.new()
			add_child(timer)
			if signal_cont.first_data > 0:
				timer.start(signal_cont.first_data)
				await timer.timeout
			EmitBaseSignal(SignalConst.SignalType.TimerTimeout,signal_cont.id)
			timer.queue_free()
		
		SignalConst.SignalType.GetDataFromPathToData:
			
			var data_ar = import_data.GetObjectFromId(
				signal_cont.first_data.category,
				signal_cont.first_data.id
				)
			
			EmitBaseSignal(
				SignalConst.SignalType.TakeDataFromPathToPath,
				signal_cont.id,
				data_ar.data[signal_cont.first_data.id_in_ar]
				)
		SignalConst.SignalType.StartDialogue:
			var reader : ReaderMain = all_reader_data[ReaderType.DialogueReader]
			reader.ReadDataName(signal_cont.first_data)
		SignalConst.SignalType.StartAudio:
			var reader : ReaderMain = all_reader_data[ReaderType.AudioReader]
			reader.ReadDataName(signal_cont.first_data)

func EmitBaseSignal(type : SignalConst.SignalType, unic_id : int, first_data : Variant = -1, second_data : Variant = -1):
	var cont := SignalDataContainer.new()
	cont.signal_type = type
	cont.first_data = first_data
	cont.second_data = second_data
	cont.id = unic_id
	BaseSignal.emit(cont)
