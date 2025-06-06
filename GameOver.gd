extends Node2D

@export var control: Control

# Called when the node enters the scene tree for the first time.
func _ready():
	ScoreTracker.connect('player_crashed', Callable(self, '_on_player_crashed'))


func _on_play_again_pressed():#change this to a global scripts that tracks the currently played level
	var _reload = get_tree().reload_current_scene()
	get_tree().paused = false
	


func _on_quit_to_menu_pressed():
	get_tree().paused = false
	ScoreTracker.load_scene('Start_Menu')
	
	
	
	
func _on_player_crashed():
	control.show()
	get_tree().paused = true
