extends Card

@export var discard_amount : int = 1 :
	set(val):
		discard_amount = val 
		rules_text.text = rules_str % discard_amount 
	get:
		return discard_amount 

@export var rules_str : String = "onplay,\ndraw %s"

func on_play(decks : RotaryDeck, entity: Entity)->void:
	#get a card into the hand
	decks.discard_random(discard_amount)
	super.on_play(decks,entity)

func _ready()->void:
	super._ready()
	rules_text.text = rules_str % self.discard_amount
