extends Spatial

export(OpenSimplexNoise) var noise
var data_tool
var mesh_instance
var surface_tool
var array_plane
var zSpeed = 1

func _ready() -> void:
	noise.period = 20.0
	noise.octaves = 6
	
	var plane_mesh = PlaneMesh.new()
	plane_mesh.size = Vector2(50,100)
	plane_mesh.subdivide_width = 25
	plane_mesh.subdivide_depth = 50
	
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
	mesh_instance.set_surface_material(0, load("res://sea.material"))
	add_child(mesh_instance)


 #Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for i in range(data_tool.get_vertex_count()):
		var vertex = data_tool.get_vertex(i)
		vertex.y = noise.get_noise_3d(vertex.x, vertex.y, vertex.z)  * 10
		
		data_tool.set_vertex(i, vertex)
		
	for i in range(array_plane.get_surface_count()):
		array_plane.surface_remove(i)
	
	data_tool.commit_to_surface(array_plane)
	surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES)
	surface_tool.create_from(array_plane, 0)
	surface_tool.generate_normals()


	mesh_instance.mesh = surface_tool.commit()
	mesh_instance.set_surface_material(0, load("res://sea.material"))
	
	mesh_instance.z += zSpeed
	
func get_next_area():
	pass
