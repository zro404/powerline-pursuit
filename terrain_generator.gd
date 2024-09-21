@tool
extends StaticBody3D

@export var update = false

@export var meshSize: int = 64
@export var subdivide: int = 63
@export var amplitude: int = 5
@export var terrainNoise = FastNoiseLite.new()


var RNG = RandomNumberGenerator.new()
var current_seed = RNG.get_seed()


var ROCK = preload("res://rock1.tscn")
var CACTUS = preload("res://cactus.tscn")
var PYLON = preload("res://electric_pylon.tscn")

var vertArr: PackedVector3Array

var pylonArr = []

func _ready() -> void:
	terrainNoise.seed = current_seed
	gen_mesh()
	gen_foliage()

func gen_mesh():
	var planeMesh = PlaneMesh.new()
	planeMesh.size = Vector2(meshSize, meshSize)
	planeMesh.subdivide_depth = subdivide
	planeMesh.subdivide_width = subdivide


	var surfTool = SurfaceTool.new()
	surfTool.create_from(planeMesh, 0)
	var data = surfTool.commit_to_arrays()
	vertArr = data[ArrayMesh.ARRAY_VERTEX]


	for i in vertArr.size():
		var vertex = vertArr[i]
		vertArr[i].y = terrainNoise.get_noise_2d(vertex.x, vertex.z) * amplitude
		vertArr[i].y = clamp(vertArr[i].y, 0, amplitude)
	data[ArrayMesh.ARRAY_VERTEX] = vertArr

	var arrMesh = ArrayMesh.new()
	arrMesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, data)

	surfTool.create_from(arrMesh, 0)
	surfTool.generate_normals()

	$TerrainMesh.mesh = surfTool.commit()
	$TerrainCollider.shape = arrMesh.create_trimesh_shape()


func gen_foliage():
	var submeshSize = (float(meshSize)/(subdivide+1))
	for v in vertArr:
		if v.x == 0 && v.z == 0:
			continue

		var obj

		if (v.z == submeshSize*2.0 || abs(v.z) == submeshSize*18.0) && fmod(v.x,submeshSize*4.0) == 0 && abs(v.x) != 500:
			obj = PYLON.instantiate()
			add_child(obj)
			obj.global_position = v
			pylonArr.append(obj)

		elif randf() > 0.9:
			if randf() >= 0.5:
				obj = CACTUS.instantiate()
			else:
				obj = ROCK.instantiate()

			add_child(obj)
			obj.global_position = v


func _process(_delta: float) -> void:
	if update:
		gen_mesh()
		update = false
