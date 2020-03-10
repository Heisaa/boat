extends ImmediateGeometry

export(OpenSimplexNoise) var noise
const SIZE = 1
const VERTICES = 30
const Z_DRIFT = 0.001

var yValues = []
var zOffset = 1.5
var grid = []
var z_sea_speed = 0.1
var lastZ = VERTICES
var seaTimer

onready var lines = get_node("../Lines")


# Called when the node enters the scene tree for the first time.
func _ready():
	self.translate(Vector3(-SIZE * VERTICES / 2, 0, -SIZE * VERTICES / 2))
	seaTimer = Timer.new()
	seaTimer.set_wait_time(0.1)
	seaTimer.connect("timeout", self, "moveSea")
	add_child(seaTimer)
	seaTimer.start()
	
	yValues = []
	for z in range(VERTICES + 1):
		yValues.append([])
		for x in range(VERTICES + 1):
			#var zTemp = z - zOffset 
			yValues[z].append(noise.get_noise_2d(x, z) * 10)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	#z_sea_speed += lines.angle_x #* Z_DRIFT
	
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
	
	
func moveSea():
	yValues.append([])
	lastZ -= zOffset
	for x in range (VERTICES + 1):
		yValues[yValues.size() - 1].append(noise.get_noise_2d(x, lastZ) * 10)
	yValues.pop_front()
	
