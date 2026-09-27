extends Resource
class_name DataStep

enum Step_Type {
START_DIALOGUE,MAKE_LINE,MAKE_CHOISE,END_DIALOGUE,CHOISE_DIALOGUE,
EMIT_DIALOGUE,AWAIT_DIALOGUE,NEXT_DIALOGUE,

StartAudio,MakeAudioOnce,MakeAudioLoop,Timer_,EndAudio}

@export var step_type : Step_Type 

@export var step_data : Variant

@export var signal_data : Variant

@export var next_step_ar : Array[DialogueStep]
