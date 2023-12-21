extends ColorRect
@onready var animation = $Fade

# Called when the node enters the scene tree for the first time.
func _ready():
	animation.play("fade_in")
