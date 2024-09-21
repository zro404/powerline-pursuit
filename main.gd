extends Node3D

@onready var camera = $Camera3D
@onready var player = $Player
@onready var playerGuidePivot = $Player/guidePivot
@onready var cameraPos: Vector3 = camera.global_position
@onready var timer = $Timer
@onready var timerLabel = $HUD/HBoxContainer/TimeLabel

@export var reward: float = 10.0

var currentPylon = -1
var defectExists = false
@onready var pylonArr = $Terrain.pylonArr

func _physics_process(_delta: float) -> void:
	camera.global_position = player.global_position+cameraPos

	playerGuidePivot.look_at_from_position(player.global_position,pylonArr[currentPylon].global_position, Vector3.UP, true)


func _process(_delta: float) -> void:
	if !defectExists:
		defectExists = true
		currentPylon = randi_range(0, pylonArr.size()-1)
		pylonArr[currentPylon].defective = true
	elif !pylonArr[currentPylon].defective:
		currentPylon = -1
		defectExists = false
		playMiniGame()

	timerLabel.text = str(int(timer.time_left))

func _on_timer_timeout() -> void:
	pass

func playMiniGame() -> void:
	var timeLeft = timer.time_left
	timer.stop()
	timer.wait_time = timeLeft + reward
	timer.start()
