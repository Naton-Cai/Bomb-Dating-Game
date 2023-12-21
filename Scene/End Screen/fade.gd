extends Node2D
@onready var fade = $Fade

# Called when the node enters the scene tree for the first time.
func _ready():
	fade.play("fade_in")
	#pass # Replace with function body.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_fade_animation_finished(anim_name):
	if anim_name == "fade_in":
		fade.play("fade_Out")
