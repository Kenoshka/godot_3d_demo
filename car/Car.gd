extends VehicleBody3D

var SPEED = 200

var WHEELS = []

var in_control = false

func _ready():
	WHEELS.append($UP_RIGHT)
	WHEELS.append($UP_LEFT)
	WHEELS.append($DOWN_LEFT)
	WHEELS.append($DOWN_RIGHT)

func get_veh_camera():
	return $Camera3D

func _process(delta):
	if in_control:
		engine_force = Input.get_axis("down", "up") * 1000
		steering = lerp(steering, Input.get_axis("right", "left") * 0.5, 5 * delta)

		apply_torque(transform.basis.x * Input.get_axis("down", "up") * 120)
		apply_torque(transform.basis.y * Input.get_axis("right", "left") * 120)
		#apply_torque(transform.basis.z * Input.get_axis("roll_left", "roll_right") * 60)

#		if Input.is_action_pressed("shift"):
#			apply_central_force(transform.basis.z * 250)
