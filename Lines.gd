extends ImmediateGeometry

onready var sea = get_node("/root/Spatial/Sea")
var angle_x = 0
var angle_z = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	self.translate(Vector3(-sea.SIZE * sea.VERTICES / 2, 0, -sea.SIZE * sea.VERTICES / 2))
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var grid_z = sea.grid.size()
	var grid_x = sea.grid[0].size()
	var line_z = [sea.grid[grid_z/2 - 1][grid_x/2][2], sea.grid[grid_z/2 + 1][grid_x/2][2]]
	var line_x = [sea.grid[grid_z/2][grid_x/2 - 2][2], sea.grid[grid_z/2][grid_x/2 + 2][2]]
	
	angle_x = -Vector2(line_z[0].z, line_z[0].y).angle_to_point(Vector2(line_z[1].z, line_z[1].y))
	angle_z = -Vector2(line_x[0].x, line_x[0].y).angle_to_point(Vector2(line_x[1].x, line_x[1].y))
	
	clear()
	begin(Mesh.PRIMITIVE_LINES)
	add_vertex(line_z[0])
	add_vertex(line_z[1])
	
	add_vertex(line_x[0])
	add_vertex(line_x[1])
	end()
	
	
	
