extends ReaderMain
class_name ReaderAudioData

const DATA_KEY = "Audio"
func GetDataKey() -> String:
	return DATA_KEY

var current_data_container : DataContainer
func ReadDataContainer(data_container : DataContainer) -> void:
	if not data_container is DataContainer:
		push_warning("data_container is not DataContainer")
		return
	if data_container.step_ar.size() <= 0:
		push_warning("Data_container Step Array Size <= 0")
		return
	
	current_data_container = data_container
	
	ReadStep(current_data_container.step_ar[0])

func ReadStep( step : DataStep, value : int = -1) -> void:
	match step.step_type:
		DataStep.Step_Type.StartAudio:
			ReadAllStep(step.next_step_ar,value)
		DataStep.Step_Type.Timer_:
			var unic_id = EmitBaseSignal(SignalConst.SignalType.TimerMake,step.step_data)
			await AwaintBaseSignal(SignalConst.SignalType.TimerTimeout,unic_id) 
			ReadAllStep(step.next_step_ar,value)
		DataStep.Step_Type.EndAudio:
			var unic_id = EmitBaseSignal(SignalConst.SignalType.AudioMakeEndAudioStream,value,step.step_data)
			await AwaintBaseSignal(SignalConst.SignalType.AudioFinishEndAudioStream,unic_id) 
			ReadAllStep(step.next_step_ar,value)
		DataStep.Step_Type.PlayAudio:
			var unic_id_0 = EmitBaseSignal(SignalConst.SignalType.GetDataFromPathToData,step.step_data)
			var mp_3 = await AwaintBaseSignal(SignalConst.SignalType.TakeDataFromPathToPath,unic_id_0)
			var unic_id_1 = EmitBaseSignal(SignalConst.SignalType.AudioPlaySound,mp_3)
			value = await AwaintBaseSignal(SignalConst.SignalType.AudioReturnSoundId, unic_id_1) 
			ReadAllStep(step.next_step_ar,value)
		DataStep.Step_Type.SetLoopAudio:
			EmitBaseSignal(SignalConst.SignalType.AudioSetLoop,value,step.step_data)
			ReadAllStep(step.next_step_ar,value)
		DataStep.Step_Type.START_DIALOGUE:
			EmitBaseSignal(SignalConst.SignalType.StartDialogue,step.step_data)
			ReadAllStep(step.next_step_ar,value)
		_:
			pass
			#EndRead.emit()

func ReadAllStep(step_ar : Array[DataStep], value : int = -1) -> void:
	for step in step_ar:
		ReadStep(step,value)
