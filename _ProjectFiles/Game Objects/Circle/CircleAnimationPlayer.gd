extends AnimationPlayer


func circle_abandoned():
	play("implode")
	yield(self, "animation_finished")
	queue_free()

func circle_captured():
	play("capture")
