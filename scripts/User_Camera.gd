extends Camera2D

var zoom_min = Vector2(.6,.6) #zoom out max
var zoom_max = Vector2(6,6) #zoom in max
var zoom_speed = Vector2(.2,.2)

func _input(event: InputEvent):
	if event is InputEventMouseMotion and Input.is_action_pressed("rightClick"):
		position -= event.relative / zoom
	
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.is_action_pressed("mouseWheelDown"):
				#print("zooming out")
				if zoom > zoom_min:
					zoom -= zoom_speed
				elif zoom < zoom_min:
					zoom = zoom_min

			if event.is_action_pressed("mouseWheelUp"):
				#print("zooming in")
				if zoom < zoom_max:
					zoom += zoom_speed
				elif zoom > zoom_max:
					zoom = zoom_max

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
