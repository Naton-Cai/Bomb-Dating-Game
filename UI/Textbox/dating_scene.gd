extends Node2D
@onready var Bomb = $Bomb
const lines: Array[String] = [
	"What would you like to say?",
	"Option 1",
	"Option 2",
	"Option 3",
	"Option 4",
]
var flag = false
var dialog_ui
var button1
var button2
var button3
var button4

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _unhandled_input(event):
	if event.is_action_pressed("open") and  not flag:
		#spawns in the dialog menu, it returns the object so we can use it later
		dialog_ui = DialogManager._spawn_dialog_box()
		
		#calls the TextManager to display the textbox aboxe the bomb
		TextManager.start_text(Bomb.global_position, lines)
		
		#starts displaying the dialog listed
		DialogManager.start_dialog(lines)
		
		#get each button from the dialog window UI
		button1 = dialog_ui.get_node("TextureRect/Entry1/VBoxContainer/Button1")
		button2 = dialog_ui.get_node("TextureRect/Entry1/VBoxContainer/Button2")
		button3 = dialog_ui.get_node("TextureRect/Entry1/VBoxContainer/Button3")
		button4 = dialog_ui.get_node("TextureRect/Entry1/VBoxContainer/Button4")
		
		#connect each button to it's corosponding signal
		button1.pressed.connect(self._on_button_1_pressed)
		button2.pressed.connect(self._on_button_2_pressed)
		button3.pressed.connect(self._on_button_3_pressed)
		button4.pressed.connect(self._on_button_4_pressed)
		
		flag = true
		
	if event.is_action_pressed("clear") && flag:
		DialogManager.clear_dialog()
		
		flag = false

func _on_button_1_pressed():
	print("button1")


func _on_button_2_pressed():
	print("button2")


func _on_button_3_pressed():
	print("button3")


func _on_button_4_pressed():
	print("button4")
