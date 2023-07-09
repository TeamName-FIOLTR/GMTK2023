extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label2.text = Globals.game_over_message
	$seduce.visible = Globals.seduced 
	$normal.visible = not Globals.seduced
