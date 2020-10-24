extends Sprite

export var chased = false

func _ready():
	$AnimationPlayer.play("spawn")
