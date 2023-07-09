extends Card

class_name ResetLibraryCard


func play_effect(_decks : RotaryDeck,_entity : Entity)->void:
	super.play_effect(_decks ,_entity)
	_decks.reset_library()
