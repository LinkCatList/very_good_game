extends Label

@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D
var tween: Tween

class TestDial:
	var wait_random
	var audio_player: AudioStreamPlayer2D
	func _init(audio_player) -> void:
		self.wait_random = 0
		self.audio_player = audio_player
		pass
		
	func sound_tween(current_time):
		print(self.audio_player.playing)
		if not self.audio_player.playing:
			self.audio_player.finished.connect(func():
				print('finished')
			)
			self.audio_player.pitch_scale = randf_range(0.8, 1.2)
			self.audio_player.play()

func dial_tween(current_time, dial_text, target_time):
	text = dial_text.substr(0, floor(current_time / target_time * dial_text.length()))


func dial(dial_text: String, target_time: float, interlocutor: bool = false):
	if tween:
		tween.stop()
	tween = get_tree().create_tween()
	var binded_tween = dial_tween.bind(dial_text, target_time);
	var test_dial = TestDial.new(audio_player)
	tween.tween_method(binded_tween, 0.0, target_time, target_time / 2)
	tween.parallel().tween_method(test_dial.sound_tween, 0.0, target_time, target_time)
	tween.tween_interval(target_time * 3 / 4)
