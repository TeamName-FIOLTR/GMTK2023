extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = "You Win!" if Globals.u_win else "Game Over..."
	$Label2.text = Globals.game_over_message
	$seduce.visible = Globals.seduced 
	$normal.visible = not Globals.seduced
	
	if Globals.seduced:
		$AudioStreamPlayer.play()
	elif Globals.u_win:
		$AudioStreamPlayer2.play()
	else:
		$AudioStreamPlayer3.play() # The Trilogy
