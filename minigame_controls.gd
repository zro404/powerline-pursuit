extends Node2D

var targetKey: String

func _ready() -> void:
	var ri = randi_range(1,4)
	if ri==1:
		targetKey = "forward"
		$W.visible = true
	elif ri==2:
		targetKey = "left"
		$A.visible = true
	elif ri==3:
		targetKey = "backward"
		$S.visible = true
	else:
		targetKey = "right"
		$D.visible = true
