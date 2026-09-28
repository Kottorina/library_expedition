extends ReaderUi
class_name ReaderAudioUi

func ReadySecond() -> void:
	pass

func BaseSignalUpdate(signal_cont : SignalDataContainer) -> void:
	await get_tree().process_frame
	match signal_cont.signal_type:
		SignalConst.SignalType.AudioPlaySound:
			var id = StartNewSound(signal_cont.body_res)
			EmitBaseSignal(SignalConst.SignalType.AudioReturnSoundId,-1,id)

var id : int = 0
var id_to_obj : Dictionary

func StartNewSound(audio_stream : AudioStreamMP3) -> int:
	
	var audio_stream_player := AudioStreamPlayer.new()
	add_child(audio_stream_player)
	audio_stream_player.stream = audio_stream
	
	audio_stream_player.play()
	
	id_to_obj[id] = audio_stream_player
	id += 1
	return id
