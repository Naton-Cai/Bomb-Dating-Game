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
		tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(self, "value", new_health, change/20).set_trans(Tween.TRANS_LINEAR)

