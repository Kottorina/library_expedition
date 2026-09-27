extends ReaderMain
class_name ReaderDialogueData

const DATA_KEY = "Dialogue"
func GetDataKey() -> String:
	return DATA_KEY

var current_data_container : DataContainer
func ReadDataContainer(data_container : DataContainer) -> void:
	if not data_container is DataDialogue:
		push_warning("data_container is not DataDialogue")
		return
	if data_container.step_ar.size() <= 0:
		push_warning("Data_container Step Array Size <= 0")
		return
	
	current_data_container = data_container
	
	ReadDialogueStep(current_data_container.step_ar[0])

func ReadDialogueStep( step : DataStep) -> void:
	
	match step.step_type:
		DialogueStep.Step_Type.START_DIALOGUE:
			EmitBaseSignal(SignalConst.SignalType.DialogueOpenAnim)
			await AwaintBaseSignal(SignalConst.SignalType.DialogueContinue)
			ReadDialogueStep(step.next_step_ar[0])
		DialogueStep.Step_Type.MAKE_LINE:
			EmitBaseSignal(SignalConst.SignalType.DialogueMakeLine,current_data_container,step)
			await AwaintBaseSignal(SignalConst.SignalType.DialogueContinue)
			ReadDialogueStep(step.next_step_ar[0])
		DialogueStep.Step_Type.MAKE_CHOISE:
			EmitBaseSignal(SignalConst.SignalType.DialogueMakeChoise,current_data_container,step)
			var value  = await AwaintBaseSignal(SignalConst.SignalType.DialogueContinue)
			print(value)
			ReadDialogueStep(step.next_step_ar[value].next_step_ar[0])
		DialogueStep.Step_Type.END_DIALOGUE:
			EmitBaseSignal(SignalConst.SignalType.DialogueCloseAnim)
			EmitBaseSignal(SignalConst.SignalType.BaseEmit,-1,step.signal_data)
		DialogueStep.Step_Type.CHOISE_DIALOGUE:
			push_warning("You should not see this message --- DialogueStep.Step_Type.CHOISE_DIALOGUE : ReaderDialogueGraphDataObject")
		DialogueStep.Step_Type.EMIT_DIALOGUE:
			EmitBaseSignal(SignalConst.SignalType.BaseEmit,-1,step.signal_data)
			ReadDialogueStep(step.next_step_ar[0])
		DialogueStep.Step_Type.AWAIT_DIALOGUE:
			EmitBaseSignal(SignalConst.SignalType.DialogueMakeLine,current_data_container,step)
			await AwaintBaseSignal(SignalConst.SignalType.DialogueContinuePreliminary)
			
			AwaintBaseSignal(SignalConst.SignalType.BaseEmit,step.signal_data)
			ReadDialogueStep(step.next_step_ar[0])
		DialogueStep.Step_Type.NEXT_DIALOGUE:
			if ReadNextDataName(step.signal_data) == false:
				EmitBaseSignal(SignalConst.SignalType.DialogueCloseAnim)
				EmitBaseSignal(SignalConst.SignalType.BaseEmit,-1,step.signal_data)
