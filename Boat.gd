extends Spatial

onready var sea = get_node("/root/Spatial/Sea")
onready var lines = get_node("../Lines")
var last_rotation = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	# Position
	var grid_z = sea.grid.size()
	var grid_x = sea.grid[0].size()
	var translation  = sea.grid[grid_z/2][grid_x/2][2] - get_translation()
	global_translate(Vector3(translation.x - 12, translation.y, translation.z - 12))
	
	# Rotation
	set_rotation(Vector3(0,0,lines.angle_z))
	rotate_x(lines.angle_x - get_rotation().x)
	
