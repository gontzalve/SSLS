extends Node2D

@export var bullet_scene: PackedScene
	

func create_bullet(spawn_pos: Vector2, direction: Vector2) -> Node2D:
	var bullet_node: Node = bullet_scene.instantiate()
	bullet_node.position = spawn_pos
	$BulletContainer.add_child(bullet_node)
	bullet_node.start_movement(direction)
	return bullet_node
