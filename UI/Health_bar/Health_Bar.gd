extends TextureProgressBar
var tween


func _ready():
	tween = get_tree().create_tween()

func set_health(new_health, change):
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(self, "value", new_health, change/20).set_trans(Tween.TRANS_LINEAR)

