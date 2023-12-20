extends TextureProgressBar
var tween
@onready var sfx = preload("res://SFX/audio.tscn")
@onready var audio_music = preload("res://SFX/Bomb Burning.wav")


func _ready():
	tween = get_tree().create_tween()

func set_health(new_health, change):
	var music
	if not is_instance_valid(music):
		music = sfx.instantiate() as AudioStreamPlayer2D
		var audio = audio_music
		music.stream = audio
		music.global_position = self.global_position
		music.volume_db = -40
		self.add_sibling(music)    
	
	if tween:
		#self.tint_progress = Color("#db4e80", 1)
		tween.kill()
	tween = get_tree().create_tween()
	tween.finished.connect(self._on_tween_finish)
	tween.tween_property(self, "value", new_health, 1).set_trans(Tween.TRANS_LINEAR)
	if change < -4:
			self.tint_progress = Color("#00a100", 1)
	if change > 5:
			self.tint_progress = Color("#fd0037", 1)
	
	#print(change)
	
func _on_tween_finish():
	self.tint_progress = Color("#db4e80", 1)
	#tween.kill()
	
	

