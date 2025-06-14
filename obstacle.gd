extends StaticBody2D

class_name obstacle

@export var size: Vector2
@export var layer: int
@export var mask: int

func _init():
	pass

func _execute():
	pass
	
func _save():
	pass

func _load():
	pass

func _ready():
	add_to_group('obstacles')

func _on_destruction_area_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group('player'):
		queue_free()
