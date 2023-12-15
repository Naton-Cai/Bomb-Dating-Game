extends Node2D
@onready var headerlabel = $TextureRect/HeaderContainer/Header
@onready var button1 = $TextureRect/Entry1/VBoxContainer/Button1
@onready var button2 = $TextureRect/Entry1/VBoxContainer/Button2
@onready var button3 = $TextureRect/Entry1/VBoxContainer/Button3
@onready var button4 = $TextureRect/Entry1/VBoxContainer/Button4
@onready var timer = $DisplayTimer

var text = ""
var letter_index = 0
var max_length = 0
var letter_time = 0.01
var isEmpty = true

signal finished_displaying()

#disables all the buttons
func disable_buttons():
	timer.stop()
	clear_text()
	button1.disabled = true
	button2.disabled = true
	button3.disabled = true
	button4.disabled = true

#enables them for use
func enable_buttons():
	button1.disabled = false
	button2.disabled = false
	button3.disabled = false
	button4.disabled = false

#clears away the text
func clear_text():
	isEmpty = true
	headerlabel.text = ""
	button1.text = ""
	button2.text = ""
	button3.text = ""
	button4.text = ""

#called by DialogManager to display the provided strings
#strings are represented in an array of size 5
#0 being the header
#1-5 being the buttons text
func display_dialog(text_to_display: Array[String]):
	text = text_to_display
	if len(text) == 5 and isEmpty == true:
		letter_index = 0
		max_length = max(text[0].length(), text[1].length(), text[2].length(), text[3].length(), text[4].length())
		enable_buttons()
		_display_letter()
		isEmpty = false
	
#function that displays each string letter by letter
func _display_letter():
	if letter_index >= max_length or len(text) < 5:
		return
	if letter_index < text[0].length():
		headerlabel.text += text[0][letter_index]
	if letter_index < text[1].length():
		button1.text += text[1][letter_index]
	if letter_index < text[2].length():
		button2.text += text[2][letter_index]
	if letter_index < text[3].length():
		button3.text += text[3][letter_index]
	if letter_index < text[4].length():
		button4.text += text[4][letter_index]
	timer.start(letter_time)
	letter_index+=1
	
	

func _on_display_timer_timeout():
	_display_letter()

func _on_button_1_pressed():
	disable_buttons()


func _on_button_2_pressed():
	disable_buttons()


func _on_button_3_pressed():
	disable_buttons()


func _on_button_4_pressed():
	disable_buttons()
