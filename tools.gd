extends Node
class_name Tools

static func coalesce(args):
	for a in args:
		if a != null:
			return a
	return null

static func is_point_over_polygon(point: Vector2, polygonNode: Polygon2D) -> bool:
	return Geometry2D.is_point_in_polygon(point, polygonNode.global_transform * polygonNode.polygon)

static func format_time(total_seconds: float) -> String:
	var hours = int(floor(total_seconds / 3600))
	var minutes = int(floor((total_seconds - hours * 3600) / 60))
	var seconds = int(floor(total_seconds - hours * 3600 - minutes * 60))

	return "{hours}:{minutes}:{seconds}".format({
		"hours": hours,
		"minutes": "%02d" % minutes,
		"seconds": "%02d" % seconds,
	})

static func time_to_seconds(time: Dictionary) -> float:
	var hours = time["hours"] if "hours" in time else 0
	var minutes = time["minutes"] if "minutes" in time else 0
	var seconds = time["seconds"] if "seconds" in time else 0

	return hours * 3600 + minutes * 60 + seconds

static func find_nodes_custom(node: Node, find_custom: Callable) -> Array[Node]:
	var nodes: Array[Node] = []
	for child in node.get_children():
		var find_result = find_custom.call(child)
		if find_result:
			nodes.append(child)
		nodes.append_array(find_nodes_custom(child, find_custom))
	
	return nodes

static func get_bounding_box(node: Node2D) -> Rect2:
	var rect := Rect2()
	var first := true

	for child in node.get_children():
		if child is CanvasItem and child.visible:
			var r: Rect2
			if child.has_method("get_rect"):
				r = child.get_rect()
				# Transform into node’s local space
				var xform = child.get_global_transform()
				var points = [
					xform * r.position,
					xform * (r.position + Vector2(r.size.x, 0)),
					xform * (r.position + Vector2(0, r.size.y)),
					xform * (r.position + r.size)
				]

				for p in points:
					if first:
						rect = Rect2(p, Vector2.ZERO)
						first = false
					else:
						rect = rect.expand(p)

		rect = rect.merge(get_bounding_box(child))

	return rect

static func find_first_node_custom(node: Node, find_custom: Callable) -> Variant:
	var stack = node.get_children()
	while stack.size() > 0:
		var current_node = stack.pop_front()
		var find_result = find_custom.call(current_node)
		if find_result:
			return current_node

		stack.append_array(current_node.get_children())
	
	return null


class RaceSignalPool:
	var _pool: Array[Dictionary]
	var _free_pool_callable: Callable

	func _init() -> void:
		pass

	func connect_signal(sig: Signal, callable: Callable, disconnect_on_free: bool = false) -> void:
		_pool.append({
			"callable": callable,
			"signal": sig,
		})
		if disconnect_on_free:
			_free_pool_callable = func():
				self._free_pool()
			sig.connect(_free_pool_callable)
		sig.connect(callable)

	func _free_pool() -> void:
		for record in _pool:
			record["signal"].disconnect(record["callable"])
			if record["signal"].is_connected(_free_pool_callable):
				record["signal"].disconnect(_free_pool_callable)
