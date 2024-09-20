extends VehicleBody3D

const MAX_STEERING = 0.6
const ENGINE_POWER = 1000

func _physics_process(delta: float) -> void:
	steering = move_toward(steering, Input.get_axis("right", "left") * MAX_STEERING, delta*2.5)
	engine_force = Input.get_axis("backward", "forward") * ENGINE_POWER
