extends Resource
class_name AudioStep

enum Step_Type {StartAudio,MakeAudioOnce,MakeAudioLoop,Timer_,EndAudio}

@export var step_type : Step_Type 

@export var step_data : Variant

@export var next_step_ar : Array[AudioStep]
