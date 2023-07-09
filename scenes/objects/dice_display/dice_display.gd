extends Node2D

class_name DiceDisplay

@export
var animation_delta : float = 0.2
@export 
var animation_length : float = 2

var offset = 0
var target_value : int = -1  :
	set(val):
		offset = 0
		cumulative_time = 0
		target_value = val 
		$AudioStreamPlayer.play()
	get:
		return target_value
		

var value : int = 1 :
	set (val):
		value = val 
		$lblRoll.text = str(val)
	get:
		return value

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
var cumulative_time : float = 0
func _process(delta):
	if target_value > 0:
		offset += delta
		cumulative_time += delta
		if offset > animation_delta:
			offset = 0
			self.value = randi()%20+1
		if cumulative_time > animation_length:
			self.value = target_value
			target_value = -1

