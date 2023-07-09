extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label2.text = Globals.game_over_message


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
