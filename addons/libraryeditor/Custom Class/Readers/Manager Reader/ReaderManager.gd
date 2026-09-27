extends Node
class_name ReaderManager 

signal central_signal

enum ReaderType {DialogueReader,AudioReader}

@export var AllSaveData : SaveDataAllLibrary
@export_group("Reader Ui")
@export var reader_dialogue_ui : ReaderMain
@export var audio_reader : Node

func StartRead(type : ReaderType,name_res : String) -> void:
	
	match type:
		ReaderType.DialogueReader:
			
			var reader = ReaderDialogueData.new()
			
			var all_bake_data : Array[DataContainer]
			
			var all_library_obj_ar = AllSaveData.GetArFromKey(reader.GetCurrentDataKey())
			for obj in all_library_obj_ar:
				if obj is GraphDataObjects:
					for bake_container in obj.bake_data_ar:
						all_bake_data.append(bake_container)
			
			print(all_bake_data)
			#reader_dialogue_ui.start_dialogue(id_,name_)
		1:
			print("!")
