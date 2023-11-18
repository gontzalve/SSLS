extends Node2D

const CELL_SIZE: int = 112
const LETTER_SIZE: int = 64

const GRID_ROWS: int = 11
const GRID_COLUMNS: int = 15

const DOUBLE_CELL_ROWS: int = 0
const DOUBLE_CELL_COLUMNS: int = 0

var grid: Array
var row_sections: Array
var column_sections: Array


func initialize() -> void:
	_initialize_grid()
	_initialize_sections()


func get_center_cell_world_pos() -> Vector2:
	var center_row: int = (GRID_ROWS - 1) / 2
	var center_column: int = (GRID_COLUMNS - 1) / 2
	return get_world_position_for_cell(Vector2(center_row, center_column))
	

func set_cell_as_occupied(cell_grid_pos: Vector2i) -> void:
	if not _is_cell_position_valid(cell_grid_pos):
		return
	grid[cell_grid_pos.x][cell_grid_pos.y] = false


func is_cell_free(cell_grid_pos: Vector2i) -> bool:
	if not _is_cell_position_valid(cell_grid_pos):
		return false
	return grid[cell_grid_pos.x][cell_grid_pos.y]
	

func get_random_free_cell() -> Vector2i:
	var tries: int = 30
	while tries > 0:
		var random_row: int = randi_range(0, GRID_ROWS - 1)
		var random_col: int = randi_range(0, GRID_COLUMNS - 1)
		var random_cell_pos: Vector2i = Vector2i(random_row, random_col)
		if is_cell_free(random_cell_pos):
			return random_cell_pos
		tries -= 1
	return -1 * Vector2i.ONE


func get_world_position_for_cell(cell_grid_pos: Vector2i) -> Vector2:
	if not _is_cell_position_valid(cell_grid_pos):
		printerr("Position not valid for %v" %cell_grid_pos)
		return Vector2.INF
	var world_pos_x = _get_world_position_x_for_cell(cell_grid_pos.y)
	var world_pos_y = _get_world_position_y_for_cell(cell_grid_pos.x)
	return Vector2(world_pos_x, world_pos_y)


func get_random_position_inside_cell(cell_grid_pos: Vector2i) -> Vector2:
	var cell_world_pos: Vector2 = get_world_position_for_cell(cell_grid_pos)
	var offset_x: float = randf_range(-1, 1)
	var offset_y: float = randf_range(-1, 1)
	var radius = randf_range(0, CELL_SIZE - LETTER_SIZE)
	var offset: Vector2 = Vector2(offset_x, offset_y).normalized() * radius
	return cell_world_pos + offset


func _initialize_grid() -> void:
	for row in range(GRID_ROWS):
		grid.append([])
		for col in range(GRID_COLUMNS):
			grid[row].append(true)


func _initialize_sections() -> void:
	var single_cell_rows = (GRID_ROWS - DOUBLE_CELL_ROWS) / 2
	var single_cell_columns = (GRID_COLUMNS - DOUBLE_CELL_COLUMNS) / 2
	row_sections.append({"Length": single_cell_rows, "CellSize": 1})
	row_sections.append({"Length": DOUBLE_CELL_ROWS, "CellSize": 2})
	row_sections.append({"Length": single_cell_rows, "CellSize": 1})
	column_sections.append({"Length": single_cell_columns, "CellSize": 1})
	column_sections.append({"Length": DOUBLE_CELL_COLUMNS, "CellSize": 2})
	column_sections.append({"Length": single_cell_columns, "CellSize": 1})


func _get_world_position_x_for_cell(column: int) -> float:
	var world_pos_x: float = CELL_SIZE / 2
	for section in column_sections:
		var min_section_length: int = mini(column, section["Length"])  
		column = column - min_section_length
		world_pos_x += min_section_length * CELL_SIZE * section["CellSize"]
		if column <= 0:
			return world_pos_x
	return world_pos_x


func _get_world_position_y_for_cell(row: int) -> float:
	var world_pos_y: float = CELL_SIZE / 2
	for section in row_sections:
		var min_section_length: int = mini(row, section["Length"])
		row = row - min_section_length
		world_pos_y += min_section_length * CELL_SIZE * section["CellSize"]
		if row <= 0:
			return world_pos_y
	return world_pos_y


func _is_cell_position_valid(cell_grid_pos: Vector2i) -> bool:
	if cell_grid_pos.x < 0 or cell_grid_pos.x >= GRID_ROWS:
		return false
	if cell_grid_pos.y < 0 or cell_grid_pos.y >= GRID_COLUMNS:
		return false
	return true

