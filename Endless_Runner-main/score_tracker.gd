extends Node

#necessay varialbe for score tracking which requires
#taking the start time of each level_start and taking time_elapsed and subtracking the start_time from it
var level_score_dictionary: Dictionary
var score: String
var level_started: bool
var start_time: float
var time_elapsed: float
var milliseconds:= 0
var seconds:= 0
var minutes:= 0

#scene handler
var current_scene: String
var all_scene: Dictionary = {'Start_Menu': preload('res://start_menu.tscn'),'Level_Test': preload("res://test_world.tscn")}

signal level_start
signal player_crashed
signal player_finished_level


func _ready():
	connect('player_crashed', Callable(self, '_on_player_crashed'))
	connect('player_finished_level', Callable(self, '_on_player_finished_level'))
	connect('level_start', Callable(self, '_on_level_start'))

func _physics_process(_delta):
	time_elapsed = Time.get_ticks_msec()
	match level_started:
		true:
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
	level_score_dictionary[str(get_tree().current_scene)] = score
	get_tree().paused = true
	await get_tree().create_timer(2).timeout
	get_tree().change_scene_to_file('res://game_over.tscn')
	get_tree().paused = false
	print(level_score_dictionary)
	
	
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
	
func calculate_time(time_elapsed):
	var level_time = time_elapsed - start_time
	milliseconds = level_time
	seconds = level_time / 1000
	minutes = level_time / 1000 / 60
	var score_string = "Time: %d:%d:%d"
	score = score_string % [minutes, seconds, milliseconds]
	return score 
	
 
