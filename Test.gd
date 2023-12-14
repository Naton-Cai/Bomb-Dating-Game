extends Sprite2D
const lines: Array[String] = [
	"Yo.",
	"hi?",
	"Wait."
]

func _unhandled_input(event):
	#print(event)
	if event.is_action_pressed("open"):
		print("TRUE")
		DialogManager.start_dialog(global_position, lines)

