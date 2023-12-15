extends Node2D
const lines: Array[String] = [
	"What would you like to say?",
	"Option 1",
	"Option 2",
	"Option 3",
	"Option 4",
]
var flag = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _unhandled_input(event):
	if event.is_action_pressed("open") and not flag:
		DialogManager._spawn_dialog_box()
		flag = true
	
	if event.is_action_pressed("advance_dialog") && flag:
		DialogManager.start_dialog(lines)
		
	if event.is_action_pressed("clear") && flag:
		DialogManager.clear_dialog()

