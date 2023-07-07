extends Area2D
class_name CardDetectingArea


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

signal card_entered(card)
signal card_exited(card)

func _on_area_entered(area):
	if area is CardArea:
		emit_signal("card_entered", area.card)
		pass
	pass # Replace with function body.


func _on_area_exited(area):
	if area is CardArea:
		emit_signal("card_exited", area.card)
	pass # Replace with function body.
