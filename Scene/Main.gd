extends Node2D
@onready var Title = preload("res://Scene/Title Screen/Title.tscn")
@onready var Date = preload("res://Scene/Date Scene/dating_scene.tscn")
@onready var End = preload("res://Scene/End Screen/end.tscn")
@onready var GoodEnd = preload("res://Scene/End Screen/GoodEnding.tscn")
@onready var EndTimer = $EndTimer

@onready var sfx = preload("res://SFX/audio.tscn")
#@onready var audio_music = preload("res://SFX/Jazz Brunch.wav")


var Title_screen
var Date_screen
var End_screen
#var Good_screen
var start_button
var restart_button
var end_timer
var end_score = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	Title_screen = Title.instantiate()
	self.add_child(Title_screen)
	start_button = Title_screen.get_node("UI/Start_Game")
	start_button.pressed.connect(self._on_Start_game_pressed)

func _on_Start_game_pressed():
	if is_instance_valid(Title_screen):
		Title_screen.queue_free()
	if is_instance_valid(End_screen):
		End_screen.queue_free()
	
	Date_screen = Date.instantiate()
	self.add_child(Date_screen)
	end_timer = Date_screen.get_node("Game_Fuse_Timer")
	end_timer.timeout.connect(self._on_game_fuse__timer_timeout)
	
	#var music = sfx.instantiate() as AudioStreamPlayer2D
	#var audio = audio_music
	#music.stream = audio
	#music.global_position = self.global_position
	#self.add_sibling(music)	
	
func _on_game_fuse__timer_timeout():
	end_score = Date_screen.score_counter
	#calls the end timer/ this was added to wait for a potential cutscene
	EndTimer.start(1)
	print(end_score)
	
func _on_end_timer_timeout():
	#print("Freeing")
	Date_screen.queue_free()
	if end_score >= 200:
		End_screen = GoodEnd.instantiate()
		self.add_child(End_screen)
		End_screen.get_node("UI/Score").text = "Score: " + str(end_score)
		restart_button = End_screen.get_node("UI/Restart")
		restart_button.pressed.connect(self._on_Start_game_pressed)
	else:
		End_screen = End.instantiate()
		self.add_child(End_screen)
		End_screen.get_node("UI/Score").text = "Score: " + str(end_score)
		restart_button = End_screen.get_node("UI/Restart")
		restart_button.pressed.connect(self._on_Start_game_pressed)
