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
		SignalConst.SignalType.AudioMakeEndAudioStream:
			await EndAudioStream(signal_cont.body_res,signal_cont.body_value)
			EmitBaseSignal(SignalConst.SignalType.AudioFinishEndAudioStream,-1,signal_cont.body_res)
		SignalConst.SignalType.AudioSetLoop:
			SetLoop(signal_cont.body_res, signal_cont.body_value)

var id : int = 0
var id_to_obj : Dictionary

func StartNewSound(audio_stream : AudioStreamMP3) -> int:
	id += 1
	var audio_stream_player := AudioStreamPlayer.new()
	add_child(audio_stream_player)
	audio_stream_player.stream = audio_stream.duplicate()
	
	audio_stream_player.play()
	
	id_to_obj[id] = audio_stream_player
	return id

func SetLoop(audio_stream_id : int, loop_setting : bool) -> void:
	print(loop_setting)
	if id_to_obj.has(audio_stream_id):
		if id_to_obj[audio_stream_id].stream is AudioStreamMP3:
			id_to_obj[audio_stream_id].stream.loop = loop_setting
		else:
			push_warning("SetLoop IS NOT AudioStreamMP3")
		
	

func EndAudioStream(audio_stream_id : int, end_time : float) -> bool:
	if id_to_obj.has(audio_stream_id):
		var tween = create_tween()
		
		tween.tween_property(
			id_to_obj[audio_stream_id], "volume_db", -80, end_time
			)
		await tween.finished
		id_to_obj[audio_stream_id].queue_free()
		id_to_obj.erase(audio_stream_id)
	print("AudioStreamPlayer Delete")
	return true
