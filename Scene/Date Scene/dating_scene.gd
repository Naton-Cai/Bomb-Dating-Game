extends Node2D
@onready var Bomb = $Bomb
@onready var round_end_timer = $round_end
@onready var Game_end_timer = $Game_Fuse_Timer
@onready var update_timer = $update
@onready var fuse_health = $ProgressBar
@onready var score = $Score
var response: Array[String] = []
var question: Array[String] = []
var reaction: Array[String] = []

var flag = false
var dialog_ui
var button1
var button2
var button3
var button4

var Active_Passive = 0
var Emotional_Logical = 0
var Extroverted_Introverted = 0
var Postive_Negative = 0

var Engagement = 100
var Romantic = 100
var Comfort = 100
var Happiness = 100

var round_counter = 0
var game_time = 60

#personality will be randomly determined from -100 to 100
func generate_personality():
	Active_Passive = randi_range( -100, 100)
	Emotional_Logical = randi_range( -100, 100)
	Extroverted_Introverted = randi_range( -100, 100)
	Postive_Negative = randi_range( -100, 100)

#generates the questions
func generate_question():
	question = ["what do you like?"]
	
	
func generate_response(q:String):
	#every 4 rounds you get to ask a question
	if round_counter%4 == 0:
		response = [
		"What would you like to ask?",
		"Option 1",
		"Option 2",
		"Option 3",
		"Option 4",
		]
	else:	
		response = [
		"What would you like to say?",
		"Option 1",
		"Option 2",
		"Option 3",
		"Option 4",
		]


func generate_reaction(r: String, answered: int):
	var array = ["I like that", "I don't like that", "I love that", "I hate that"]
	reaction = [str(array[answered])]
	#calls the TextManager to display the textbox aboxe the bomb
	TextManager.start_text(Bomb.global_position, reaction)
	
	
#generates each round
func generate_round():
	round_counter += 1
	score.text = "Score: "+str(round_counter)
	
	generate_question()
	generate_response(question[0])
	#spawns in the dialog menu, it returns the object so we can use it later
	dialog_ui = DialogManager._spawn_dialog_box()
	#starts displaying the dialog listed
	DialogManager.start_dialog(response)
	
	#calls the TextManager to display the textbox aboxe the bomb
	TextManager.start_text(Bomb.global_position, question)
	
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


#calcuates the drain effect on each emotional bar
func calculate_drain():
	var time_deducted = 0
	if Engagement > 0:
		Engagement = max(0, Engagement-10)
	else:
		time_deducted += 1
	if Romantic > 0:	
		Romantic = max(0, Romantic-10)
	else:
		time_deducted += 1
	if Comfort > 0:	
		Comfort = max(0, Comfort-10)
	else:
		time_deducted += 1
	if Happiness > 0:	
		Happiness = max(0, Happiness-10)
	else:
		time_deducted += 1
	Game_end_timer.wait_time = max(Game_end_timer.time_left-time_deducted, 1)
	if !Game_end_timer.is_stopped() and Game_end_timer.wait_time >= 1:
		Game_end_timer.start()


func _on_button_1_pressed():
	print("button1")
	DialogManager.clear_dialog()
	TextManager.clear_text()
	generate_reaction(response[1],0)
	round_end_timer.start(1)


func _on_button_2_pressed():
	print("button2")
	DialogManager.clear_dialog()
	TextManager.clear_text()
	generate_reaction(response[2],1)
	round_end_timer.start(1)


func _on_button_3_pressed():
	print("button3")
	DialogManager.clear_dialog()
	TextManager.clear_text()
	generate_reaction(response[3],2)
	round_end_timer.start(1)


func _on_button_4_pressed():
	print("button4")
	DialogManager.clear_dialog()
	TextManager.clear_text()
	generate_reaction(response[4],3)
	round_end_timer.start(1)


#the end of this timer starts the game
func _on_start_timeout():
	generate_personality()
	generate_round()
	Game_end_timer.start()
	update_timer.start()
	
	
#the end of this timer represents a new round
func _on_round_end_timeout():
	DialogManager.clear_dialog()
	TextManager.clear_text()
	generate_round()

#this timer repesents the end of the game
func _on_game_fuse__timer_timeout():
	print("GAME OVER")
	fuse_health.set_health(Game_end_timer.time_left,20)
	update_timer.stop()
	round_end_timer.stop()
	pass # Replace with function body.

func _on_update_timeout():
	calculate_drain()
	fuse_health.set_health(Game_end_timer.time_left,20)
	game_time = Game_end_timer.time_left
	print(Engagement, Romantic, Comfort, Happiness)
