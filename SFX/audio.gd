extends AudioStreamPlayer2D
var end_timer 

# Called when the node enters the scene tree for the first time.
func _ready():
	#end_timer = self.get_root().get_node("Main/Dating_Scene/Game_Fuse_Timer")
	#print(end_timer)
	#end_timer.timeout.connect(self._on_game_fuse__timer_timeout)
	self.play()

	
func _physics_process(delta):
	await self.finished
	self.queue_free()

#func _on_game_fuse__timer_timeout():
	#
