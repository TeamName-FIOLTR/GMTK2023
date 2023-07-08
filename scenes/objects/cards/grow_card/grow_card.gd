extends Card

class_name GrowCard



func play_effect(_decks : RotaryDeck,_entity : Entity)->void:
	super.play_effect(_decks ,_entity)
	self.number += 1 #we get STRONK


