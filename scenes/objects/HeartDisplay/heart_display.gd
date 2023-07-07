extends Node2D


var single_heart = preload("res://scenes/objects/HeartDisplay/single_heart.tscn")

@export 
var max_health : int = 4
@export 
var current_health : int = 3


@export 
var direction : Vector2 = Vector2(1,0)
@export 
var heart_spacing : float = 510


#ensures we have the correct number of hearts under neith the hp container
func init_hearts()->void:
	var start : float = -heart_spacing * max_health  / 4
	for i in range(max_health / 2):
		var h = single_heart.instantiate()
		h.position = direction*(i*heart_spacing+start) 
		$transform.add_child(h)
func update_heart_values()->void:
	var hp_tmp = current_health 
	for i in range($transform.get_child_count()):
		var eat_amount = 0
		if hp_tmp >= 2:
			eat_amount = 2
		elif hp_tmp == 1:
			eat_amount = 1
		hp_tmp -= eat_amount 
		print(eat_amount)
		$transform.get_child(i).frame = eat_amount
# Called when the node enters the scene tree for the first time.
func _ready():
	init_hearts()
	update_heart_values()
