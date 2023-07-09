extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	self.pressed.connect(load_game)
func load_game()->void:
	get_tree().change_scene_to_file("res://scenes/levels/test/test_level.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
