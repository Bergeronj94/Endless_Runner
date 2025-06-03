extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_play_pressed():
	var test_world_scene = preload("res://test_world.tscn")
	get_tree().change_scene_to_packed(test_world_scene)
