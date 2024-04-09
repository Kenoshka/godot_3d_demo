extends RigidBody3D

var substr = preload("res://grenade/substractor.tscn")

func _ready():
	$Timer.start(3)

func _on_timer_timeout():
	for body in $ExplosionArea.get_overlapping_bodies():
		if body is RigidBody3D:
			var vec_length = (body.global_position - global_position).length()
			var vec = (body.global_position - global_position).normalized() * (600 - (vec_length * 100))
			body.apply_force(vec * body.mass)
	var substractor = substr.instantiate()
	substractor.position = global_position
	get_parent().get_node("WorldMesh").get_node("SUB").add_child(substractor)
	$FreeTimer.start(0.2)
	$Expolsion.visible = true


func _on_free_timer_timeout():
	queue_free()
