extends Node3D

@onready var playButton = $Menu/PlayButton

var game = preload("res://game.tscn")

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		$PauseMenu.visible = !$PauseMenu.visible


func _on_play_button_button_down() -> void:
	add_child(game.instantiate())
	$Menu.queue_free()


func _on_exit_button_button_down() -> void:
	get_tree().quit()
