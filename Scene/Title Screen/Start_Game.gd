extends Button
@onready var sfx = preload("res://SFX/audio.tscn")
@onready var audio_click = preload("res://SFX/Clicking.wav")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_button_down():
	var sound = sfx.instantiate() as AudioStreamPlayer2D
	sound.stream = audio_click
	sound.global_position = self.global_position
	self.add_sibling(sound)
	pass # Replace with function body.
