extends TileMap

@onready var cell_searcher = get_node("/root/Main/CellSearcher")
@onready var world_map = get_node("/root/Main/ProjectZomboidVanillaMap")

var tile_mouse_position
var last_tile_mouse_position = null
var change_counter = 0
var counter_max = 20
var random_vector = Vector2(0, 0)

func _input(event: InputEvent):
	if event is InputEventMouseMotion:
		cursor_coordinates(event)

# Called when the node enters the scene tree for the first time.
func _ready():
	world_map.add_layer(1)
	world_map.set_layer_z_index (1, 1)
	
	world_map.add_layer(2)
	world_map.set_layer_z_index (2, 2)
	
	set_map_cells()
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	cursor_coordinates(null)

func cursor_coordinates(event):
	tile_mouse_position = world_map.local_to_map(world_map.get_local_mouse_position()) 
	
	if change_counter >= counter_max:
			change_counter = 0
			random_vector = getRandomVectorInRange()
	else:
		change_counter += 1
	
	if event is InputEventMouseMotion:
		clear_layer(2)
		if tile_mouse_position != null:
			last_tile_mouse_position = tile_mouse_position
			set_cell(2, tile_mouse_position, 1, random_vector)
			
		pass
	elif last_tile_mouse_position != null:
		set_cell(2, last_tile_mouse_position, 1, random_vector)
	pass


func set_map_cells():
	var mod_maps_data_dictionary = cell_searcher.map_mods_data_loader()
	for map_name in mod_maps_data_dictionary:
		var cell_list = mod_maps_data_dictionary[map_name]
		var random_vector = getRandomVectorInRange()

		for cell in cell_list:
			#print('"' + map_name + '" :', cell)
			var vector2_cell = Vector2(cell[0], cell[1])
			set_cell(1, vector2_cell, 1, random_vector)
	
func getRandomVectorInRange() -> Vector2:
	var min_range = Vector2(0, 0)
	var max_range = Vector2(15, 1)
	
	var random_x = randf_range(min_range.x, max_range.x)
	var random_y = randf_range(min_range.y, max_range.y)

	return Vector2(random_x, random_y)


