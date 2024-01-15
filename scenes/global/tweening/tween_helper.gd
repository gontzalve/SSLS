extends Node


func create(node: Node) -> SimpleTween:
	var simple_tween: SimpleTween = SimpleTween.new(node)
	return simple_tween