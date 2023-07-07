extends Node2D
class_name Card

@export var number : int = 10

func _init(card_number = 100):
	number=card_number


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_input_area_input_event(viewport, event, shape_idx):
	
	pass # Replace with function body.
