extends Card

@export var draw_amount : int = 1 :
	set(val):
		draw_amount = val 
		rules_text.text = rules_str % draw_amount 
	get:
		return draw_amount 

@export var rules_str : String = "onplay,\ndraw %s"

func on_play(decks : RotaryDeck, entity: Entity)->void:
	#get a card into the hand
	for i in range(self.draw_amount):
		decks.draw()	
	super.on_play(decks,entity)

func _ready()->void:
	super._ready()
	rules_text.text = rules_str % self.draw_amount
