extends Control

class_name TalkBox

@export var lbltext : RichTextLabel

var type_index : int = 0
var target_text : String = "" :
	set(val):
		target_text = val 
		type_index = 0
		$TypeTimer.start()
		$SoundTimeout.start()
	get:
		return target_text

func clear_text()->void:
	lbltext.text = ""
func pop_letter()->void:
	lbltext.text += target_text[type_index]
	type_index += 1
func on_tttimeout():
	if type_index < len(target_text):
		pop_letter()
	else:
		$SoundTimeout.stop()
		$TypeTimer.stop()
func on_type_sound_timeout():
	$AudioStreamPlayer.play(3.0)
# Called when the node enters the scene tree for the first time.
func _ready():
	$TypeTimer.timeout.connect(on_tttimeout)
	$SoundTimeout.timeout.connect(on_type_sound_timeout)
