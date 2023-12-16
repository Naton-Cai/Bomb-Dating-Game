extends ColorRect
@onready var countdown = $Label
@onready var Start = $Start

func _on_start_timeout():
	self.visible = false

func _physics_process(delta):
	countdown.text = str(int(Start.time_left*2)+1)
