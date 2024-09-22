extends Node3D

@onready var playButton = $Menu/PlayButton

var game = preload("res://game.tscn")
var gi

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		$PauseMenu.visible = !$PauseMenu.visible
	if Global.gameOver:
		Global.gameOver = false
		gi.queue_free()
		$GameOver.visible = true


func _on_play_button_button_down() -> void:
	gi = game.instantiate()
	add_child(gi)
	$Menu.visible = false


func _on_exit_button_1_button_down() -> void:
	get_tree().quit()

func _on_exit_button_2_button_down() -> void:
	get_tree().quit()

func _on_restart_button_down() -> void:
	gi = game.instantiate()
	add_child(gi)
	$GameOver.visible = false
