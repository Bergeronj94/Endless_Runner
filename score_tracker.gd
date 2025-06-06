extends Node

#necessay varialbe for score tracking
var level_score_dictionary: Dictionary
var score: int 
var level_started: bool

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
	match level_started:
		true:
			score = int(Engine.get_frames_drawn() / Engine.get_frames_per_second())

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
	level_score_dictionary[str(get_tree().current_scene)] = score
	
	
func _on_level_start():
	current_scene = get_tree().current_scene.name
	print(current_scene)
	level_started = true

func load_scene(packed_scene):
	var new_scene = ScoreTracker.all_scene[packed_scene]
	get_tree().change_scene_to_packed(new_scene)
	
