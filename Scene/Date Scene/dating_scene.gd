extends Node2D
@onready var Bomb = $Bomb
@onready var round_end_timer = $round_end
@onready var Game_end_timer = $Game_Fuse_Timer
@onready var update_timer = $update
@onready var fuse_health = $Fuse
@onready var score = $UI/Score

@onready var ComfortBar = $UI/ComfortBar
@onready var EngageBar = $UI/EngageBar
@onready var RomanceBar = $UI/RomanceBar
@onready var HappinessBar = $UI/HappinessBar
@onready var text_json = JSON.parse_string(FileAccess.get_file_as_string("res://UI/Dialog/questions.json"))

@onready var animation = $Bomb/AnimationPlayer

var current_question_num = null
var response_values: Array[int] = [-1,-1,-1,-1]

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
var score_counter = 0
var game_time = 60

func generate_negative_positive(x: int):
	if(bool(randi() % 2)):
		return x
	else:
		return x*-1

#personality will be randomly determined from -100 to 100
func generate_personality():
	Active_Passive = generate_negative_positive(10)
	Emotional_Logical = generate_negative_positive(10)
	Extroverted_Introverted = generate_negative_positive(10)
	Postive_Negative = generate_negative_positive(10)

#generates the questions
func generate_question():
	if round_counter%4 == 0 and round_counter != 0:
		current_question_num = -1
		question = ["What would you want to know about me?"]
	else:
		var temp = randi_range(0, text_json.size()-1)
		#ensures we don't have immediate repeats
		while temp == current_question_num:
			temp = randi_range(0, text_json.size()-1)	
		current_question_num = temp
		question = [text_json[current_question_num]["question"]]
	
	
	
func generate_response(q:String):
	#every 4 rounds you get to ask a question
	if round_counter%4 == 0 and round_counter != 0 or current_question_num == -1:
		response = [
		"What would you like to ask?",
		"Are you more positive or negative
		[Happiness]",
		"Are introverted or extroverted
		[Comfort]",
		"Are you an active or passive person
		[Engagment]",
		"Do you think more emotionally or logically
		[Romance]",
		]
	else:
		#gets 4 random rensponses with no duplicates
		var response_text= []
		var list = text_json[current_question_num]["answers"].duplicate() 
		for i in range(len(list)):
			list[i] = [list[i]["response"], i]
		for j in range(4):
			var x = randi()%list.size()
			response_values[j] = list[x][1]
			response_text.append(list[x][0])
			list.remove_at(x)
			
			
		#print(response_values)
		#print(text_json[current_question_num]["answers"][response_values[0]]["response"], response_text[0])
		#print(text_json[current_question_num]["answers"][response_values[1]]["response"], response_text[1])
		#print(text_json[current_question_num]["answers"][response_values[2]]["response"], response_text[2])
		#print(text_json[current_question_num]["answers"][response_values[3]]["response"], response_text[3])
		response = [
		"What would you like to say?",
		response_text[0],
		response_text[1],
		response_text[2],
		response_text[3],
		]


func generate_reaction(r: String, answered: int):
	animation.play("Talking")
	if round_counter%4 == 0 and round_counter != 0:
		score_counter += 10
		match(answered):
			0:
				if Postive_Negative > 0:
					reaction = ["No likee, I'm soo positive omg."]
				else:
					reaction = ["No, I'm quite negative about things."]
			1:
				if Extroverted_Introverted > 0:
					reaction = ["I'm quite extroverted."]
				else:
					reaction = ["I'd say I'm introverted."]
			2:
				if Active_Passive > 0:
					reaction = ["I'm very active"]
				else:
					reaction = ["Eh, I'm a passive person"]
			3:
				if Emotional_Logical > 0:
					reaction = ["I'm very emotional"]
				else:
					reaction = ["I'm sooo logical"]
			_:
				reaction = ["ERROR"]
			
	else:
		var ap = text_json[current_question_num]["answers"][response_values[answered]]["weight"][0]*Active_Passive
		var el = text_json[current_question_num]["answers"][response_values[answered]]["weight"][1]*Emotional_Logical
		var ei = text_json[current_question_num]["answers"][response_values[answered]]["weight"][2]*Extroverted_Introverted
		var pn = text_json[current_question_num]["answers"][response_values[answered]]["weight"][3]*Postive_Negative
		var total_points = ap+el+ei+pn+4
		
		score_counter += max(0, total_points)
		calculate_drain(ap+1,el+1,ei+1,pn+1)
		"""
		print(ap," ", Active_Passive," ",)
		print(el, " ", Emotional_Logical," ",)
		print(ei," ",  Extroverted_Introverted," ",)
		print(pn," ",  Postive_Negative," ",)
		print(r, text_json[current_question_num]["answers"][response_values[answered]]["response"])
		"""
		
		
		#print(total_points)
		if total_points >= 0 and total_points <= 10:
			reaction = ["Oh okay vibe."]
		elif total_points < 0 and total_points >= -10:
			reaction =["Uhhh okay?"]
		elif total_points > 10:
			reaction = ["OMG I loveee thhaat"]
		elif total_points < -10:
			reaction = ["Ewww"]
		else:
			reaction = ["Huh?"]
	#calls the TextManager to display the textbox aboxe the bomb
	TextManager.start_text(Bomb.global_position, reaction)
	
	
#generates each round
func generate_round():
	#print(text_json.size())
	generate_question()
	generate_response(question[0])
	#spawns in the dialog menu, it returns the object so we can use it later
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
func calculate_drain(eng, rom, com, hap):
	var time_deducted = 0
	if Engagement <= 0 and eng < 0:
		time_deducted -= eng/5
	EngageBar.set_health(Engagement, Engagement-max(0, Engagement+eng))
	Engagement = max(0, Engagement+eng)
		
	if Romantic <= 0 and rom < 0:	
		time_deducted -= rom/5
	RomanceBar.set_health(Romantic,Romantic-max(0, Romantic+rom))
	Romantic = max(0, Romantic+rom)
		
	if Comfort <= 0 and com < 0:
		time_deducted -= com/5
	ComfortBar.set_health(Comfort, Comfort-max(0, Comfort+com))
	Comfort = max(0, Comfort+com)
		
	if Happiness <= 0 and hap < 0:
		time_deducted -= hap/5	
	HappinessBar.set_health(Happiness,Happiness-max(0, Happiness+hap))
	Happiness = max(0, Happiness+hap)
	
	Game_end_timer.wait_time = max(Game_end_timer.time_left-time_deducted, 0.5)
	if !Game_end_timer.is_stopped() and Game_end_timer.wait_time >= 1:
		Game_end_timer.start()


func _on_button_1_pressed():
	DialogManager.clear_dialog()
	TextManager.clear_text()
	generate_reaction(response[1],0)
	round_end_timer.start(0.5)
	round_counter += 1
	score.text = "Score: "+str(score_counter)


func _on_button_2_pressed():
	DialogManager.clear_dialog()
	TextManager.clear_text()
	generate_reaction(response[2],1)
	round_end_timer.start(0.5)
	round_counter += 1
	score.text = "Score: "+str(score_counter)

func _on_button_3_pressed():
	DialogManager.clear_dialog()
	TextManager.clear_text()
	generate_reaction(response[3],2)
	round_end_timer.start(0.5)
	round_counter += 1
	score.text = "Score: "+str(score_counter)

func _on_button_4_pressed():
	DialogManager.clear_dialog()
	TextManager.clear_text()
	generate_reaction(response[4],3)
	round_end_timer.start(0.5)
	round_counter += 1
	score.text = "Score: "+str(score_counter)

#the end of this timer starts the game
func _on_start_timeout():
	score.text = "Score: "+str(score_counter)
	generate_personality()
	dialog_ui = DialogManager._spawn_dialog_box()
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
	fuse_health.set_health(Game_end_timer.time_left,20)
	print("GAME OVER")
	DialogManager.clear_box()
	TextManager.clear_text()
	update_timer.stop()
	round_end_timer.stop()

#calls an update once ever 1 second
func _on_update_timeout():
	calculate_drain(-5,-5,-5,-5)
	fuse_health.set_health(Game_end_timer.time_left,20)
	game_time = Game_end_timer.time_left
	#print(Engagement, Romantic, Comfort, Happiness)
