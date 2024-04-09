extends CharacterBody3D

const SPEED = 10
const JUMP_VELOCITY = 4.5

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var grenade = preload("res://grenade/grenade.tscn")

var holding_object = null
var active_vehicle = null

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta):
	$SubViewport/MapCamera.global_position.x = global_position.x
	$SubViewport/MapCamera.global_position.z = global_position.z
	if not is_on_floor():
		velocity.y -= gravity * delta
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	move_and_slide()


func _input(event):
	if event.is_action_pressed("lmb"):
		if holding_object == null:
			var bodies = $Camera/Marker3D/Area3D.get_overlapping_bodies()
			if bodies.size() > 0:
				if bodies[0] is VehicleBody3D:
					active_vehicle = bodies[0]
					start_to_ride(bodies[0])
					return
				if bodies[0] is RigidBody3D:
					holding_object = bodies[0]
					set_process(true)
		elif holding_object != null:
			var marker_pos = $Camera/Marker3D.global_position
			var vec = (marker_pos - global_position).normalized()
			holding_object.linear_velocity = Vector3.ZERO
			holding_object.angular_velocity = Vector3.ZERO
			holding_object.inertia = Vector3.ZERO
			holding_object.apply_force(vec * 1000 * holding_object.mass)
			holding_object = null
			set_process(false)
	if event.is_action_pressed("rbm") and holding_object != null:
		holding_object.linear_velocity = Vector3.ZERO
		holding_object.angular_velocity = Vector3.ZERO
		holding_object = null
		set_process(false)
	if event is InputEventMouseMotion:
		rotation.y += -event.relative.x * 0.005
		$Camera.rotation.x += -event.relative.y * 0.005
		$Camera.rotation.x = clamp($Camera.rotation.x, deg_to_rad(-90.0), deg_to_rad(90.0))
	if event.is_action_pressed("grenade"):
		var granata = grenade.instantiate()
		var marker_pos = $Camera/Marker3D.global_position
		var vec = (marker_pos - global_position).normalized()
		get_parent().add_child(granata)
		granata.global_position = marker_pos
		granata.apply_force(vec * 800)
	if event.is_action_pressed("Map"):
		$Map.visible = !$Map.visible
	if event.is_action_pressed("escape") and active_vehicle != null:
		stop_to_ride()

func start_to_ride(vehicle):
	get_parent().remove_child(self)
	vehicle.add_child(self)
	active_vehicle.in_control = true
	visible = false
	vehicle.get_veh_camera().current = true

func stop_to_ride():
	active_vehicle.remove_child(self)
	active_vehicle.get_parent().add_child(self)
	active_vehicle.in_control = false
	global_position = active_vehicle.global_position + Vector3(0, 2, 0)
	visible = true
	$Camera.current = true
	active_vehicle = null

func _process(delta):
	if holding_object != null:
		var marker_pos = $Camera/Marker3D.global_position
		var obj_pos = holding_object.global_position
		var velocity_vector = (marker_pos - obj_pos).normalized()
		var dist = marker_pos.distance_to(obj_pos)
		holding_object.linear_velocity = velocity_vector * dist * 15
		holding_object.angular_velocity = lerp(holding_object.angular_velocity, Vector3.ZERO, 1 * delta)

func _on_area_3d_body_entered(body):
	if body is RigidBody3D:
		$Camera/Device.add_body(body)


func _on_area_3d_body_exited(body):
	if body is RigidBody3D:
		$Camera/Device.remove_body(body)
