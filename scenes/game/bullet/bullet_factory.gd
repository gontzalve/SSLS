extends Node2D

@export var bullet_scene: PackedScene
	

func create_bullet(spawn_pos: Vector2) -> Node2D:
	var bullet_node: Node = bullet_scene.instantiate()
	bullet_node.position = spawn_pos
	$BulletContainer.add_child(bullet_node)
	return bullet_node


func destroy_all_bullets() -> void:
	var bullets: Array[Node] = $BulletContainer.get_children()
	for i in range(bullets.size() -1, -1, -1):
		if is_instance_valid(bullets[i]):
			bullets[i].queue_free()
