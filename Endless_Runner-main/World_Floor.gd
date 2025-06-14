extends StaticBody2D

@export var player: CharacterBody2D
@export var obstacle_spawner: Node2D

signal score_reached

# Called when the node enters the scene tree for the first time.
func _ready():
	connect('score_reached', Callable(self, '_on_score_reached'))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
		
func _on_score_reached():
	position = Vector2(player.global_position.x, 0)
		
