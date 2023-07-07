extends Node2D

class_name IntentIndicator

@export 
var rotation_time : float  = 1.0
@export 
var total_anim_time : float = 2.0

var to_set : int = 0
var selected : int = 0 :
	set (val):
		if (val >= self.get_child_count()):
			val = val % self.get_child_count()
		get_child(selected).visible = false
		
		selected = val 
		
		get_child(selected).visible = true
	get:
		return selected


var offset_time : float = 0
var animation_time : float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	animate_set(0)

func animate_set(val : int):
	to_set = val 
	animation_time = 0
	offset_time = 0

func _process(delta):
	if to_set != -1:
		if offset_time >= rotation_time:
			self.selected += 1
			offset_time = 0 
		if animation_time >= total_anim_time:
			self.selected = to_set
			to_set = -1
		
		offset_time += delta 
		animation_time += delta
