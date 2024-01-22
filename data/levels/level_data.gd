extends Resource

class_name LevelData

@export var level_number: int
@export var level_word: String
@export var is_tutorial: bool
@export var duration: float
@export var correct_letter_repetitions: int 
@export var level_rings: int

func _to_string() -> String:
    return "[%d]: %s in %f seconds with %d rings" %[level_number, level_word, duration, level_rings]