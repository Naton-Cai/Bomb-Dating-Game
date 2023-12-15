extends Node

@onready var dialog_box_scene = preload("res://UI/Dialog/dialog.tscn")
var dialog_lines: Array[String]
var current_line_index = 0

var dialog_box


func start_dialog(lines: Array[String]):
	dialog_lines = lines
	dialog_box.display_dialog(dialog_lines)

func clear_dialog():
	dialog_box.clear_text()
	dialog_box.disable_buttons()
	
func _spawn_dialog_box():
	dialog_box = dialog_box_scene.instantiate()
	get_tree().root.add_child(dialog_box)
