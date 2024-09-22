extends Node3D

@onready var camera = $Camera3D
@onready var player = $Player
@onready var playerGuidePivot = $Player/guidePivot
@onready var cameraPos: Vector3 = camera.global_position
@onready var timer = $Timer
@onready var timerLabel = $HUD/VBoxContainer/HBoxContainer/TimeLabel
@onready var rewardContainer = $HUD/VBoxContainer/RewardContainer
@onready var rewardLabel = $HUD/VBoxContainer/RewardContainer/RewardLabel
@onready var subViewPort = $HUD/MinigameView/SubViewport
@onready var rewardHideTimer = $RewardHideTimer
@onready var feedbackAudio = $FeedbackAudio

@export var reward: float = 10.0

var minigame = preload("res://minigame.tscn")

var timeLeft
var mGame

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
		playMiniGame()

	timerLabel.text = str(int(timer.time_left))

func _on_timer_timeout() -> void:
	Global.gameOver = true

func playMiniGame() -> void:
	if subViewPort.get_children().size() == 0:
		feedbackAudio.play()
		set_physics_process(false)
		timeLeft = timer.time_left
		timer.stop()
		mGame = minigame.instantiate()
		subViewPort.add_child(mGame)
		$HUD/MinigameView.visible = true

	if mGame.current == 4 && !mGame.is_in_area:
		feedbackAudio.play()
		$HUD/MinigameView.visible = false
		mGame.queue_free()
		currentPylon = -1
		defectExists = false
		var rew = calcReward(mGame.score)
		timer.wait_time = timeLeft + rew
		rewardContainer.visible = true
		rewardLabel.text = str(int(rew))
		rewardHideTimer.start()
		timer.start()
		set_physics_process(true)


func calcReward(score: int) -> float:
	return score*reward


func _on_reward_hide_timer_timeout() -> void:
	rewardContainer.visible = false
