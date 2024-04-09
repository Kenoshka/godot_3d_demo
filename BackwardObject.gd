extends RigidBody3D

class_name Backward_Item

var POSITIONS = []
var ROTATIONS = []

var TIMER = null
var REWINDING_TIMER = null
var is_rewinding = false

# Called when the node enters the scene tree for the first time.
func _ready():
	var timer = Timer.new()
	timer.connect("timeout", timer_timeout)
	connect("sleeping_state_changed", sleep_state)
	TIMER = timer
	add_child(timer)
	timer.start(0.1)

	var rewinding_timer = Timer.new()
	rewinding_timer.connect("timeout", rewind_timer_timeout)
	rewinding_timer.one_shot = true
	REWINDING_TIMER = rewinding_timer
	add_child(rewinding_timer)
	print(REWINDING_TIMER)

func sleep_state():
	if sleeping:
		TIMER.stop()
	else:
		TIMER.start(0.1)

func timer_timeout():
	if not is_rewinding:
		POSITIONS.push_front(global_position)
		ROTATIONS.push_front(global_rotation)
	if POSITIONS.size() > 50:
		POSITIONS.remove_at(50)
	if ROTATIONS.size() > 50:
		ROTATIONS.remove_at(50)

func rewind_timer_timeout():
	is_rewinding = false
	linear_velocity = Vector3.ZERO

func rewind_time():
	is_rewinding = true
	REWINDING_TIMER.start(POSITIONS.size() * 0.1)
	if POSITIONS.size() > 0:
		var tw = create_tween()
		for pos in POSITIONS:
			tw.tween_property(self, "global_position", pos, 0.1)
	if ROTATIONS.size() > 0:
		var tw = create_tween()
		for rot in ROTATIONS:
			tw.tween_property(self, "global_rotation", rot, 0.1)
	POSITIONS = []
	ROTATIONS = []


func _input(event):
	if event.is_action_pressed("rewind"):
		rewind_time()
