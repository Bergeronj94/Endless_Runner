extends Node


var timer: Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	timer = Timer.new()
	get_tree().root.get_node('Test_World').add_child(timer)
	timer.autostart = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
