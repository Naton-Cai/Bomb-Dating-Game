extends Node2D
@onready var headerlabel = $TextureRect/HeaderContainer/Header
@onready var button1 = $TextureRect/Entry1/VBoxContainer/Button1
@onready var button2 = $TextureRect/Entry1/VBoxContainer/Button2
@onready var button3 = $TextureRect/Entry1/VBoxContainer/Button3
@onready var button4 = $TextureRect/Entry1/VBoxContainer/Button4
@onready var timer = $DisplayTimer
@onready var sfx = preload("res://SFX/audio.tscn")
@onready var audio_click = preload("res://SFX/Clicking.wav")

var text = ""
var letter_index = 0
var max_length = 0
var letter_time = 0.0005
var isEmpty = true

signal finished_displaying()

#disables all the buttons
func disable_buttons():
	timer.stop()
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
	headerlabel.text += text[0]
	button1.text += text[1]
	button2.text += text[2]
	button3.text += text[3]
	button4.text += text[4]
	#timer.start(letter_time)
	
	

func _on_display_timer_timeout():
	_display_letter()

func _on_button_1_pressed():
	var sound = sfx.instantiate() as AudioStreamPlayer2D
	sound.stream = audio_click
	sound.global_position = self.global_position
	self.add_sibling(sound)
	disable_buttons()


func _on_button_2_pressed():
	var sound = sfx.instantiate() as AudioStreamPlayer2D
	sound.stream = audio_click
	sound.global_position = self.global_position
	self.add_sibling(sound)
	disable_buttons()


func _on_button_3_pressed():
	var sound = sfx.instantiate() as AudioStreamPlayer2D
	sound.stream = audio_click
	sound.global_position = self.global_position
	self.add_sibling(sound)
	disable_buttons()


func _on_button_4_pressed():
	var sound = sfx.instantiate() as AudioStreamPlayer2D
	sound.stream = audio_click
	sound.global_position = self.global_position
	self.add_sibling(sound)
	disable_buttons()
