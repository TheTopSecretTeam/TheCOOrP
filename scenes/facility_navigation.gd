extends Node

var graph: Dictionary[int, Array] = {}

func _ready() -> void:
	Global.reset_globals.connect(reset)

func reset() -> void:
	graph.clear()

func get_agent_path(ind_A: int, ind_B: int) -> Array[int]:
	# If start and end are the same, return immediately
	if ind_A == ind_B:
		return []
	
	# Queue for BFS: each element is a node to process
	var queue = []
	queue.append(ind_A)
	
	# Dictionary to record the path: key=node, value=parent node
	var parent = {}
	parent[ind_A] = -1 # Mark start node with no parent
	
	# Set to track visited nodes
	var visited = {}
	visited[ind_A] = true
	
	# BFS traversal
	while queue:
		var current = queue.pop_front()
		
		# Check neighbors of the current node
		for neighbor in graph.get(current, []):
			if not visited.has(neighbor):
				visited[neighbor] = true
				parent[neighbor] = current
				queue.append(neighbor)
				
				# If destination is reached, reconstruct path
				if neighbor == ind_B:
					var path: Array[int] = []
					var node = ind_B
					while node != -1:
						path.append(node)
						node = parent.get(node, -1)
					path.reverse()
					return path
	
	# Return empty array if no path exists
	return []
