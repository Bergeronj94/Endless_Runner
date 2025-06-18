extends StaticBody2D
#meeeeeeeeeeeeeeeeeeeeeeep
@export var anim: AnimatedSprite2D

func _ready():
	anim.play('idle')
	is_in_group('obstacles')

func _on_floating_area_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group('player'):
		anim.play('launched')
		print(area.get_parent().velocity)
		area.get_parent().velocity += Vector2(area.get_parent().SPEED, area.get_parent().JUMP_VELOCITY)
		print(area.get_parent().velocity)
		queue_free()
