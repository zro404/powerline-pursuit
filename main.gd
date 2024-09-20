extends Node3D

@onready var camera = $Camera3D
@onready var player = $Player
@onready var cameraPos: Vector3 = camera.global_position

func _physics_process(_delta: float) -> void:
	camera.global_position = player.global_position+cameraPos
	# camera.global_position.y = cameraPos.y
