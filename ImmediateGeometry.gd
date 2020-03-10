extends ImmediateGeometry

export(OpenSimplexNoise) var noise
const SIZE = 1
const VERTICES = 25
const Z_DRIFT = 0.001

var yValues = []
var zOffset = 0
var grid = []
var z_sea_speed = 1.5

onready var lines = get_node("../Lines")


# Called when the node enters the scene tree for the first time.
func _ready():
	self.translate(Vector3(-SIZE * VERTICES / 2, 0, -SIZE * VERTICES / 2))
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	yValues = []
	for z in range(VERTICES + 1):
		yValues.append([])
		for x in range(VERTICES + 1):
			var zTemp = z - zOffset 
			yValues[z].append(noise.get_noise_2d(x, zTemp) * 10) 
	
	#z_sea_speed += lines.angle_x #* Z_DRIFT
	zOffset += clamp(z_sea_speed, 1, 10) * delta
	#print(z_sea_speed)
	
	self.clear()
	self.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	grid = []
	for z in range(VERTICES):
		grid.append([])
		for x in range(VERTICES):
			#first triangle
			var firstTri = [
				Vector3(x * SIZE, yValues[z][x], z * SIZE), 
				Vector3((x + 1) * SIZE, yValues[z][x + 1], z * SIZE), 
				Vector3(x * SIZE, yValues[z + 1][x], (z + 1) * SIZE),
				]
			add_vertex(firstTri[0])
			add_vertex(firstTri[1])
			add_vertex(firstTri[2])
			
			#second triangle
			var secondTri = [
				Vector3((x + 1) * SIZE, yValues[z][x + 1], z * SIZE),
				Vector3((x + 1)  * SIZE, yValues[z + 1][x + 1], (z + 1) * SIZE),
				Vector3(x * SIZE, yValues[z + 1][x], (z + 1) * SIZE),
			]
			add_vertex(secondTri[0])
			add_vertex(secondTri[1])
			add_vertex(secondTri[2])
			
			grid[z].append(firstTri)
			grid[z].append(secondTri)
	self.end()
	
	
