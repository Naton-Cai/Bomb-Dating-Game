extends TextureProgressBar
@onready var fire = $Fire
var tween

func _ready():
	tween = get_tree().create_tween()

func set_health(new_health, change):
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(self, "value", new_health, change/20).set_trans(Tween.TRANS_LINEAR)
	
func _physics_process(delta):
	fire.position.x = (self.value)*(1704/60)
	if self.value == 0:
		fire.visible = false
		
