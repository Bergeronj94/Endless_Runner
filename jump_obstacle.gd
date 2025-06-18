extends StaticBody2D

@export var size: Vector2
@export var layer: int
@export var mask: int
@export var anim: AnimatedSprite2D

func _ready():
	anim.play('default')
	add_to_group('obstacles')

func _init():
	pass

func _execute():
	pass
	
func _save():
	pass

func _load():
	pass
