extends AudioStreamPlayer2D
var end_timer 

# Called when the node enters the scene tree for the first time.
func _ready():
	#end_timer = self.get_root().get_node("Main/Dating_Scene/Game_Fuse_Timer")
	print(end_timer)
	#end_timer.timeout.connect(self._on_game_fuse__timer_timeout)
	self.play()
	await self.finished
	
	

#func _on_game_fuse__timer_timeout():
	#self.queue_free()
