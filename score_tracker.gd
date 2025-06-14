extends Node

#-> eventually get to it
# TODO 1: Refactoring and Core Logic Improvements
# - **Store raw time (milliseconds) in the dictionary for simpler comparisons.**
# - **Ensure the new best time is correctly assigned to the dictionary only if it's an improvement.**
# - **Use a dedicated variable for the current run's duration for better clarity.**
# - **Rename the time calculation function to reflect its formatting purpose.**

# TODO 2: Scene and Game Flow Improvements
# - **Implement level completion based on in-level objectives, not just hardcoded time.**
# - **Refine game over scene handling for smoother transitions.**
# - **Consider making this script an Autoload for global accessibility.**

# TODO 3: Save/Load and General Best Practices
# - **Update the save file path to be cross-platform compatible.**
# - **Add error handling for file operations during saving and loading.**
# - **Gracefully handle levels with no prior scores when checking for best times.**

#necessay varialbe for score tracking which requires
#taking the start time of each level_start and taking time_elapsed and subtracking the start_time from it
var level_score_dictionary: Dictionary
var score: String
var level_started: bool
var start_time: int
var time_elapsed: int
var milliseconds:= 0.0
var seconds:= 0.0
var minutes:= 0.0

#scene handler
var current_scene: String
var all_scene: Dictionary = {'Start_Menu': preload('res://start_menu.tscn'), 'Level_Select': preload('res://level_select.tscn'), 'Test_World': preload("res://test_world.tscn")}

signal level_start
signal player_crashed
signal player_finished_level


func _ready():
	load_game()
	connect('player_crashed', Callable(self, '_on_player_crashed'))
	connect('player_finished_level', Callable(self, '_on_player_finished_level'))
	connect('level_start', Callable(self, '_on_level_start'))

func _physics_process(_delta):
	time_elapsed = Time.get_ticks_msec()
	match level_started:
		true: #need to incorporate a way to check the score and the times aren't right zzzzzzzzz
			score = calculate_time(time_elapsed)
			

func _on_player_crashed():
	level_started = false
	get_tree().paused = true
	var gameOver = preload('res://game_over.tscn')
	var gameOver_scene = gameOver.instantiate()
	var scene = get_tree().root.get_children()
	for node in scene:
		if is_instance_valid(Node2D) and node.name.begins_with('Test'):
			node.add_child(gameOver_scene)
	
	
func _on_player_finished_level():
	print('score tracker player finished level')
	check_score(current_scene)
	level_score_dictionary[get_tree().current_scene.name] = score
	get_tree().paused = true
	await get_tree().create_timer(2).timeout
	get_tree().change_scene_to_file('res://game_over.tscn')
	get_tree().paused = false
	save_game()
	
	
func _on_level_start():
	start_time = Time.get_ticks_msec()
	score = ''
	current_scene = get_tree().current_scene.name
	print(current_scene)
	level_started = true

func load_scene(packed_scene):
	var new_scene = ScoreTracker.all_scene[packed_scene]
	get_tree().change_scene_to_packed(new_scene)

func determine_level_end():
	match current_scene:
		'Level_Test':
			if seconds > 30:
				emit_signal('player_finished_level')
func reset():
	score = ''
	time_elapsed = 0
	
func calculate_time(time_elapsed): #okay i had ai help me with this because i forgot to do the remainder part
	var level_time_ms = time_elapsed - start_time # Assuming start_time is also in milliseconds
	var milliseconds_display = level_time_ms % 1000
	var total_seconds = level_time_ms / 1000 # Integer division for total seconds
	var seconds_display = total_seconds % 60 # Remainder for seconds part
	var minutes_display = total_seconds / 60 # Integer division for minutes part
	var score_string = "Time: %02d:%02d:%04d" # Use %02d for two digits, %04d for four digits
	var score = score_string % [minutes_display, seconds_display, milliseconds_display]
	return score

func check_score(current_level): #we call this check whenever the level finishes and only assign score when the new_time is less than the old_time
	var new_time = time_elapsed - start_time
	var old_time_uncoded = ScoreTracker.level_score_dictionary[current_level]
	old_time_uncoded = old_time_uncoded.split(':')
	var old_time = int((int(old_time_uncoded[1]) * 60) + (int(old_time_uncoded[2]) * 1000) + int(old_time_uncoded[3]))
	print(new_time, old_time_uncoded, old_time)
	if new_time < int(old_time):
		print(new_time)
		print(old_time)
		calculate_time(new_time)
	else:
		print(new_time < int(old_time))
		score = level_score_dictionary[current_scene]
		
	
func save_game():
	var file = FileAccess.open('/home/toomuchtosay/Documents/My Games/Endless Runner/save_file.dat', FileAccess.WRITE)
	file.store_string(JSON.stringify(level_score_dictionary))
	
func load_game():
	if FileAccess.file_exists('/home/toomuchtosay/Documents/My Games/Endless Runner/save_file.dat'):
		var file = FileAccess.open('/home/toomuchtosay/Documents/My Games/Endless Runner/save_file.dat', FileAccess.READ)
		var content = file.get_as_text()
		level_score_dictionary = JSON.parse_string(content)
