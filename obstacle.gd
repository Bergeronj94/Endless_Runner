extends StaticBody2D

class_name obstacle

@export var size: Vector2
@export var layer: int
@export var mask: int
@export var anim: AnimatedSprite2D
@export var collision: CollisionShape2D

func _init():
	pass

func _execute():
	pass
	
func _save():
	pass

func _load():
	pass

func _ready():
	anim.play('default')
	add_to_group('obstacles')

func _on_destruction_area_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group('player'):
		ScoreTracker.emit_signal('obstacle_destroyed')
		collision_layer = 20
		collision_mask = 20
		anim.play('break') 
		await get_tree().create_timer(0.25).timeout
		anim.play('broken')
