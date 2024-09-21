extends StaticBody3D

var defective: bool = false
@onready var feedbackMesh = $FeedbackMesh

func _process(_delta: float) -> void:
	feedbackMesh.visible = defective



func _on_area_3d_player_entered(_body:Node3D) -> void:
	if defective:
		defective = false
