extends Node3D

func _ready():
	var box_mesh = BoxMesh.new()
	box_mesh.size = Vector3(100, 1, 100)
	$WorldMesh.mesh = box_mesh

func optimize_landscape():
	$WorldMesh.mesh = $WorldMesh.get_meshes()[1].duplicate()
	for child in $WorldMesh/SUB.get_children():
		child.queue_free()


func _on_sub_child_entered_tree(node):
	if $WorldMesh/SUB.get_child_count() > 3:
		$WorldMesh/Timer.start(0.1)


func _on_timer_timeout():
	optimize_landscape()
