extends Control
@onready var world_map = get_node("/root/Main/ProjectZomboidVanillaMap")
@onready var user_camera = get_node("/root/Main/UserCamera")

@onready var debug_screen := get_node("/root/Main/UserCamera/CanvasLayer/DebugScreen")
@onready var zoom_info := get_node("/root/Main/UserCamera/CanvasLayer/DebugScreen/Background/Zoom")
@onready var coordinates_info := get_node("/root/Main/UserCamera/CanvasLayer/DebugScreen/Background/Coordinates")

var mouse_tile_position
var zoom_info_text: String = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	cursor_coordinates()
	zoom_informer()


func cursor_coordinates():
#	print(camera2d.scale) #Debug
	var mouse_position = get_global_mouse_position()
#	print(mouse_position) #Debug
	mouse_tile_position = world_map.local_to_map(world_map.get_local_mouse_position())  #world_map.local_to_map(mouse_position)
#	print(tile_mouse_pos) #Debug
	coordinates_info.text = "Cell Coordinates: " + str(mouse_tile_position.x) + ", " + str(mouse_tile_position.y)
	
func zoom_informer():
	zoom_info_text = str(snapped(user_camera.zoom.x, 0.01))
	zoom_info.text = "Zoom: " + zoom_info_text 
	
