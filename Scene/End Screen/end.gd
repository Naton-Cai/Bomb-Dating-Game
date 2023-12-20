extends Node2D
@onready var label = $Label
@onready var sfx = preload("res://SFX/audio.tscn")
@onready var audio_click = preload("res://SFX/Clicking.wav")




func _on_restart_button_down():
	var sound = sfx.instantiate() as AudioStreamPlayer2D
	sound.stream = audio_click
	sound.global_position = self.global_position
	self.add_sibling(sound)
	pass # Replace with function body.
