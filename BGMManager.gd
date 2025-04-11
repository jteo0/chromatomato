extends Node

@onready var bgm_player = AudioStreamPlayer.new()  
var current_bgm: AudioStream  

func _ready():  
	add_child(bgm_player)  
	bgm_player.process_mode = Node.PROCESS_MODE_ALWAYS  

func play_bgm(bgm_stream: AudioStream, loop: bool = true):  
	if bgm_player.stream == bgm_stream and bgm_player.playing:  
		return  
	
	if bgm_stream is AudioStreamWAV or bgm_stream is AudioStreamOggVorbis:
		bgm_stream.loop = loop
	
	bgm_player.stream = bgm_stream  
	bgm_player.play()  

func stop_bgm():  
	bgm_player.stop()  
