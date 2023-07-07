extends Control


@export var lbltext : RichTextLabel

var type_index : int = 0
var target_text : String = "" :
	set(val):
		target_text = val 
		$TypeTimer.start()
	get:
		return target_text


func pop_letter()->void:
	lbltext.text += target_text[type_index]
	$AudioStreamPlayer.play()
	type_index += 1
func on_tttimeout():
	if type_index < len(target_text):
		pop_letter()
	else:
		$TypeTimer.stop()
# Called when the node enters the scene tree for the first time.
func _ready():
	$TypeTimer.timeout.connect(on_tttimeout)
