extends Area2D


func _on_body_entered(body: Node2D) -> void:
	print('finished level')
	if body.is_in_group('player'):
		ScoreTracker.emit_signal('player_finished_level') #will make sure the player finishes the level
