extends ReaderMain
class_name ReaderDialogueData

const DATA_KEY = "Dialogue"
func GetDataKey() -> String:
	return DATA_KEY

var current_data_container : DataContainer
func ReadDataContainer(data_container : DataContainer, unic_code : int = UnicId.NullValue) -> void:
	if not data_container is DataDialogue:
		push_warning("data_container is not DataDialogue")
		return
	if data_container.step_ar.size() <= 0:
		push_warning("Data_container Step Array Size <= 0")
		return
	
	current_data_container = data_container
	
	ReadDialogueStep(current_data_container.step_ar[0], unic_code)

func ReadDialogueStep( step : DataStep, unic_code : int) -> void:
	
	match step.step_type:
		DialogueStep.Step_Type.START_DIALOGUE:
			if flag_is_first_read == true:
				var unic_id = EmitBaseSignal(SignalConst.SignalType.DialogueOpenAnim)
				await AwaintBaseSignal(SignalConst.SignalType.DialogueContinue, unic_id)
			ReadDialogueStep(step.next_step_ar[0], unic_code)
		DialogueStep.Step_Type.MAKE_LINE:
			var unic_id = EmitBaseSignal(SignalConst.SignalType.DialogueMakeLine,current_data_container,step)
			await AwaintBaseSignal(SignalConst.SignalType.DialogueContinue, unic_id)
			ReadDialogueStep(step.next_step_ar[0], unic_code)
		DialogueStep.Step_Type.MAKE_CHOISE:
			var unic_id = EmitBaseSignal(SignalConst.SignalType.DialogueMakeChoise,current_data_container,step)
			var value  = await AwaintBaseSignal(SignalConst.SignalType.DialogueContinue, unic_id)
			ReadDialogueStep(step.next_step_ar[value].next_step_ar[0], unic_code)
		DialogueStep.Step_Type.END_DIALOGUE:
			EmitBaseSignal(SignalConst.SignalType.DialogueCloseAnim)
			EmitBaseSignal(SignalConst.SignalType.BaseEmit,step.signal_data)
			#EndRead.emit()
		DialogueStep.Step_Type.CHOISE_DIALOGUE:
			push_warning("You should not see this message --- DialogueStep.Step_Type.CHOISE_DIALOGUE : ReaderDialogueGraphDataObject")
			EmitBaseSignal(SignalConst.SignalType.DialogueCloseAnim)
			EmitBaseSignal(SignalConst.SignalType.BaseEmit,step.signal_data)
			#EndRead.emit()
		DialogueStep.Step_Type.EMIT_DIALOGUE:
			EmitBaseSignal(SignalConst.SignalType.BaseEmit,step.signal_data)
			ReadDialogueStep(step.next_step_ar[0], unic_code)
		DialogueStep.Step_Type.AWAIT_DIALOGUE:
			var unic_id = EmitBaseSignal(SignalConst.SignalType.DialogueMakeLine,current_data_container,step)
			await AwaintBaseSignal(SignalConst.SignalType.DialogueContinuePreliminary, unic_id)
			await AwaintBaseSignal(SignalConst.SignalType.BaseEmit,unic_id)
			ReadDialogueStep(step.next_step_ar[0], unic_code)
		DialogueStep.Step_Type.NEXT_DIALOGUE:
			flag_is_first_read = false
			if ReadDataName(step.signal_data) == false:
				EmitBaseSignal(SignalConst.SignalType.DialogueCloseAnim)
				EmitBaseSignal(SignalConst.SignalType.BaseEmit,-1,step.signal_data)
				#EndRead.emit()
		DialogueStep.Step_Type.StartAudio:
			EmitBaseSignal(SignalConst.SignalType.StartAudio,step.step_data)
			ReadDialogueStep(step.next_step_ar[0], unic_code)
		_:
			EmitBaseSignal(SignalConst.SignalType.DialogueCloseAnim)
			EmitBaseSignal(SignalConst.SignalType.BaseEmit,-1,step.signal_data)
			#EndRead.emit()
