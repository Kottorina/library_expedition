extends Node
class_name ReaderManager 

signal central_signal

enum ReaderType {DialogueReader,AudioReader}

@export var AllSaveData : SaveDataAllLibrary
@export_group("ReaderNode")
@export var dealogue_reader : ReaderDialogueUiGraphDataObject
@export var audio_reader : Node

func StartRead(type : ReaderType,id_ : int,name_ : String) -> void:
	
	match type:
		0:
			dealogue_reader.start_dialogue(id_,name_)
		1:
			print("!")
