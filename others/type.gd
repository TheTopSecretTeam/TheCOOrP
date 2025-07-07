extends Node
## append_array for separate chaining
func dict_add_array(d: Dictionary, keys: Array, items: Array) -> void:
	for i in range(mini(keys.size(), items.size())):
		if keys[i] not in d or d[keys[i]] == null:
			d[keys[i]] = [items[i]]
		else:
			d[keys[i]].append(items[i])

func get_children_of_type(node: Node, child_type):
	var list = []
	for i in range(node.get_child_count()):
		var child = node.get_child(i)
		if is_instance_of(child, child_type):
			list.append(child)
	return list
