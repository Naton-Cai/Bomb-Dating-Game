extends Node2D
@onready var Title = preload("res://Scene/Title Screen/Title.tscn")
@onready var Date = preload("res://Scene/Date Scene/dating_scene.tscn")
@onready var End = preload("res://Scene/End Screen/end.tscn")
@onready var GoodEnd = preload("res://Scene/End Screen/GoodEnding.tscn")
@onready var trans = preload("res://Scene/End Screen/Transition.tscn")
@onready var fade = preload("res://Scene/End Screen/fade.tscn")
@onready var EndTimer = $EndTimer

@onready var sfx = preload("res://SFX/audio.tscn")
@onready var audio_music = preload("res://SFX/Jazz Brunch.wav")
@onready var audio_rumble = preload("res://SFX/explode.wav")


var Title_screen
var Date_screen
var End_screen
var trans_screen
var fade_screen

var music
var fade_anim
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
	if is_instance_valid(music):
		music.queue_free()
	
	Date_screen = Date.instantiate()
	self.add_child(Date_screen)
	end_timer = Date_screen.get_node("Game_Fuse_Timer")
	end_timer.timeout.connect(self._on_game_fuse__timer_timeout)
	
	music = sfx.instantiate() as AudioStreamPlayer2D
	var audio = audio_music
	music.stream = audio
	music.global_position = self.global_position
	self.add_sibling(music)	
	
func _on_game_fuse__timer_timeout():
	end_score = Date_screen.score_counter
	#calls the end timer/ this was added to wait for a potential cutscene
	EndTimer.start(1)
	print(end_score)
	
func _on_end_timer_timeout():
	music.volume_db -= 5
	var rumble = sfx.instantiate() as AudioStreamPlayer2D
	var audio = audio_rumble
	rumble.stream = audio
	rumble.volume_db += 5
	rumble.global_position = self.global_position
	self.add_sibling(rumble)	
	
	
	Date_screen.queue_free()
	trans_screen = trans.instantiate()
	self.add_child(trans_screen)
	
	fade_screen = fade.instantiate()
	self.add_child(fade_screen)
	
	fade_anim = fade_screen.get_node("Fade")
	fade_anim.animation_finished.connect(self._on_fade_animation_finished)
	
func _on_fade_animation_finished(anim_name):
	if anim_name == "fade_in":
		trans_screen.queue_free()
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
