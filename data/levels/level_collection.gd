extends Resource

class_name LevelCollection

@export var levels: Array[Resource]

func get_level(level_index: int) -> LevelData:
    if level_index < 0 or level_index >= levels.size():
        return null
    return levels[level_index]
