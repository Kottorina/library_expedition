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
			var unic_code = Time.get_unix_time_from_system() + step.step_data
			EmitBaseSignal(SignalConst.SignalType.TimerMake,unic_code,step.step_data)
			await AwaintBaseSignal(SignalConst.SignalType.TimerTimeout,unic_code) 
			ReadAllStep(step.next_step_ar,value)
		DataStep.Step_Type.EndAudio:
			EmitBaseSignal(SignalConst.SignalType.AudioMakeEndAudioStream,value,step.step_data)
			await AwaintBaseSignal(SignalConst.SignalType.AudioFinishEndAudioStream,value) 
			ReadAllStep(step.next_step_ar,value)
		DataStep.Step_Type.PlayAudio:
			EmitBaseSignal(SignalConst.SignalType.GetDataFromPathToData,step.step_data)
			var mp_3 = await AwaintBaseSignal(SignalConst.SignalType.TakeDataFromPathToPath)
			EmitBaseSignal(SignalConst.SignalType.AudioPlaySound,mp_3)
			value = await AwaintBaseSignal(SignalConst.SignalType.AudioReturnSoundId) 
			ReadAllStep(step.next_step_ar,value)
		_:
			EndRead.emit()

func ReadAllStep(step_ar : Array[DataStep], value : int = -1) -> void:
	for step in step_ar:
		ReadStep(step,value)
