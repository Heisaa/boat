extends Spatial

export(OpenSimplexNoise) var noise
var data_tool
var mesh_instance
var surface_tool
var array_plane
var zSpeed = 0
var material = load("res://sea.material")

func _ready() -> void:
	noise.period = 20.0
	noise.octaves = 6
	
	var plane_mesh = PlaneMesh.new()
	plane_mesh.size = Vector2(50,50)
	plane_mesh.subdivide_width = 25
	plane_mesh.subdivide_depth = 25
	
	surface_tool = SurfaceTool.new()
	surface_tool.create_from(plane_mesh, 0)
	
	array_plane = surface_tool.commit()
	
	data_tool = MeshDataTool.new()
	data_tool.create_from_surface(array_plane, 0)
	
	for i in range(data_tool.get_vertex_count()):
		var vertex = data_tool.get_vertex(i)
		vertex.y = noise.get_noise_3d(vertex.x, vertex.y, vertex.z) * 10
		
		data_tool.set_vertex(i, vertex)
	
	for i in range(array_plane.get_surface_count()):
		array_plane.surface_remove(i)
	
	data_tool.commit_to_surface(array_plane)
	surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES)
	surface_tool.create_from(array_plane, 0)
	surface_tool.generate_normals()
	
	mesh_instance = MeshInstance.new()
	mesh_instance.mesh = surface_tool.commit()
	mesh_instance.set_surface_material(0, material)

	add_child(mesh_instance)


 #Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for i in range(data_tool.get_vertex_count()):
		var vertex = data_tool.get_vertex(i)
		var zOffset = vertex.z + zSpeed
		vertex.y = noise.get_noise_3d(vertex.x, vertex.y, zOffset)  * 10
		data_tool.set_vertex(i, vertex)

	array_plane.surface_remove(0)

	data_tool.commit_to_surface(array_plane)
	
	surface_tool.clear()
	surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES)
	surface_tool.create_from(array_plane, 0)
	surface_tool.generate_normals()

	mesh_instance.mesh = surface_tool.commit()
	mesh_instance.set_surface_material(0, material)
	zSpeed -= 0.05
	
	
