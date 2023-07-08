extends Node2D
class_name Deck

@export var cards : Array[Card]


func remove(val : Card)->void:
	cards.erase(val)

#returns a single card and removes it from the array
func draw()->Card:
	var ret_val = cards[0]
	cards.remove_at(0)
	return ret_val

# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
