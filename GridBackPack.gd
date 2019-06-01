extends TextureRect

var items = []

var grid = {}
var cell_size = 32
var grid_width = 0
var grid_height = 0

func create_empty_grid():
	for x in range(grid_width):
		grid[x] = {}
		for y in range(grid_height):
			grid[x][y] = false  # mark this grid cell as empty (occupied = "false")
		
		
# Called when the node enters the scene tree for the first time.
func _ready():
	var s = get_grid_size(self)
	grid_width = s.width
	grid_height = s.height
	create_empty_grid()

			
			
func insert_item(item):
	# set item_pos to the center of the top-left cell
	var item_pos = item.rect_global_position + Vector2(cell_size/2, cell_size/2)
	
	var g_pos = pos_to_grid_coord(item_pos)
	var item_size_in_cells = get_grid_size(item)
	
	if is_grid_space_available(g_pos, item_size_in_cells):
		set_grid_space(g_pos, item_size_in_cells, true)
		item.rect_global_position = rect_global_position + Vector2(g_pos.x, g_pos.y) * cell_size
		items.append(item)
		return true
	else:
		return false


func grab_item(pos):
	var item = get_item_under_pos(pos)
	if item == null:
		return null
		
	var item_pos = item.rect_global_position + Vector2(cell_size/2, cell_size/2)
	var g_pos = pos_to_grid_coord(item_pos)
	var item_size_in_cells = get_grid_size(item)
	set_grid_space(g_pos, item_size_in_cells, false)
	
	items.remove(items.find(item))
	return item
	
	
func get_item_under_pos(pos):
	for item in items:
		if item.get_global_rect().has_point(pos):
			return item
	return null
	
	
	
func set_grid_space(pos, item_size_in_cells, state):
	for i in range(pos.x, pos.x + item_size_in_cells.width):
		for j in range(pos.y, pos.y + item_size_in_cells.height):
			grid[i][j] = state
	
		
func is_grid_space_available(pos, item_size_in_cells):
	if pos.x < 0 or pos.y < 0:
		return false
	if pos.x + item_size_in_cells.width > grid_width or pos.y + item_size_in_cells.height > grid_height:
		return false
		
	# check every cell in the grid if it's occupied	
	for i in range(pos.x, pos.x + item_size_in_cells.width):
		for j in range(pos.y, pos.y + item_size_in_cells.height):
			if grid[i][j]:  # is occupied already
				return false
	return true
	
	
func pos_to_grid_coord(pos):
	var local_pos = pos - rect_global_position
	var results = {}
	results.x = int(local_pos.x / cell_size)
	results.y = int(local_pos.y / cell_size)
	return results
	

func get_grid_size(item):
# return the item's size in units of cell_size
	var results = {}
	var s = item.rect_size
	results.width = clamp(int(s.x / cell_size), 1, 500)
	results.height = clamp(int(s.y / cell_size), 1, 500)
	return results
	
	
func insert_item_at_first_available_spot(item):
	for y in range(grid_height):
		for x in range(grid_width):
			if !grid[x][y]:
				item.rect_global_position = rect_global_position + Vector2(x, y) * cell_size
				if insert_item(item):
					return true
	return false

