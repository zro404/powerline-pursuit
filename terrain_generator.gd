@tool
extends StaticBody3D

@export var update = false

@export var meshSize: int = 64
@export var subdivide: int = 63
@export var amplitude: int = 5
@export var frequency: int = 1
@export var noise = FastNoiseLite.new()

var RNG = RandomNumberGenerator.new()
var current_seed = RNG.get_seed()

func _ready() -> void:
	noise.frequency = 0.001*frequency
	noise.seed = current_seed
	gen_mesh()

func gen_mesh():
	var planeMesh = PlaneMesh.new()
	planeMesh.size = Vector2(meshSize, meshSize)
	planeMesh.subdivide_depth = subdivide
	planeMesh.subdivide_width = subdivide


	var surfTool = SurfaceTool.new()
	surfTool.create_from(planeMesh, 0)
	var data = surfTool.commit_to_arrays()
	var vertices = data[ArrayMesh.ARRAY_VERTEX]


	# for vertex in vertices:
	for i in vertices.size():
		var vertex = vertices[i]
		vertices[i].y = noise.get_noise_2d(vertex.x, vertex.z) * amplitude
	data[ArrayMesh.ARRAY_VERTEX] = vertices

	var arrMesh = ArrayMesh.new()
	arrMesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, data)

	surfTool.create_from(arrMesh, 0)
	surfTool.generate_normals()

	$TerrainMesh.mesh = surfTool.commit()
	$TerrainCollider.shape = arrMesh.create_trimesh_shape()



func _process(_delta: float) -> void:
	if update:
		gen_mesh()
		update = false
