extends Node2D

@export var speed = 10

@onready var objContainer = $ObjContainer
@onready var scoreLabel = $Score/ScoreLabel
@onready var targetActive = $Target/TargetActive

var score: int = 0

var current: int = 0

var is_in_area = false

func _process(_delta: float) -> void:
	objContainer.velocity = Vector2(-speed,0)
	objContainer.move_and_slide()

	scoreLabel.text = str(score)

	targetActive.visible = is_in_area

	if is_in_area:
		var didGetInput = false
		if Input.is_action_just_pressed($ObjContainer/MinigameControls.targetKey):
			didGetInput = true
			if current == 1:
				score+=2
				is_in_area = false
		if Input.is_action_just_pressed($ObjContainer/MinigameControls2.targetKey):
			didGetInput = true
			if current == 2:
				score+=2
				is_in_area = false
		if Input.is_action_just_pressed($ObjContainer/MinigameControls3.targetKey):
			didGetInput = true
			if current == 3:
				score+=2
				is_in_area = false
		if Input.is_action_just_pressed($ObjContainer/MinigameControls4.targetKey):
			didGetInput = true
			if current == 4:
				score+=2
				is_in_area = false

		if(didGetInput):
			score = max(score-1, 0)

func _on_target_body_entered(_body: Node2D) -> void:
	is_in_area = true
	current += 1


func _on_target_body_exited(_body: Node2D) -> void:
	is_in_area = false
