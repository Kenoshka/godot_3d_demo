extends CSGBox3D

var radar_dict = {}

var radar_point = preload("res://device/radar_obj.tscn")

func _ready():
	var child = $Camera2D
	remove_child(child)
	$SubViewport.add_child(child)


func _process(delta):
	$SubViewport/Camera2D/LineArea.rotation += delta * 3
	for body in radar_dict:
		if body is RigidBody3D:
			var vec = Vector2((body.global_position - get_parent().global_position).x, (body.global_position - get_parent().global_position).z)
			radar_dict[body].position = (vec * 15).rotated(get_parent().global_rotation.y)

func add_body(body):
	var point = radar_point.instantiate()
	$SubViewport/Camera2D.add_child(point)
	radar_dict[body] = point

func remove_body(body):
	radar_dict[body].queue_free()
	radar_dict.erase(body)


func _on_line_area_area_entered(area):
	area.modulate.a = 1
	create_tween().tween_property(area, "modulate:a", 0, 0.5)
