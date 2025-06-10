extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_play_pressed():
	var test_world_scene = preload("res://test_world.tscn")
	get_tree().change_scene_to_packed(test_world_scene)


func _on_level_select_pressed() -> void:
	var level_select_scene = preload('res://level_select.tscn')
	get_tree().change_scene_to_packed(level_select_scene)
