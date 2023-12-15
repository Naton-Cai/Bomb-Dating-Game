extends Sprite2D
const lines: Array[String] = [
	"Yo. What are you doing today? What?",
	"hi?",
	"Wait."
]

func _unhandled_input(event):
	#print(event)
	if event.is_action_pressed("open"):
		print("TRUE")
		TextManager.start_text(global_position, lines)

