extends CanvasLayer

@export var Test_World_label: Label
@export var Test_World_Score: Label
@export var World_1: Label
@export var World_1_Score: Label

func _ready():
	Test_World_label.text = "Test World"
	World_1.text = 'World I'
	
	#setting up the shit for the shit if the dictionary exists
	if len(ScoreTracker.level_score_dictionary.keys()) >0:
		Test_World_Score.text = ScoreTracker.level_score_dictionary['Test_World']
func _on_test_world_play_pressed() -> void:
	var test_world_scene = 'Test_World'
	ScoreTracker.load_scene(test_world_scene)

func _on_world_1_play_pressed() -> void:
	pass #eventually have another world work
