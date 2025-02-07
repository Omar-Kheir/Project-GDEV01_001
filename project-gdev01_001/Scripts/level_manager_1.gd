extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Eventbus.finishLevel.connect(changeLevel)
	
func changeLevel():
	get_tree().change_scene_to_file.bind("res://Scenes/Levels/level_2.tscn").call_deferred()
