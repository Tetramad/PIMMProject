extends Control

onready var node = preload("res://TrieNode.tscn")

export(String) var test_word
export(bool) var testit = false

var root = null

func _ready():
	root = node.instance()
	add_child(root)
	root.set_character('ROOT')
	root.set_position(Vector2.ZERO)
	relocate()

func _process(delta):
	if testit:
		insert(test_word)
		test_word = ""
		testit = false

func insert(word: String):
	var child_node = root.get_child_node()
	var children = child_node.get_children()
	for index in range(word.length()):
		var founded = false
		for child in children:
			if child.get_character()[0] == word[index]:
				child_node = child.get_child_node()
				children = child_node.get_children()
				founded = true
				break
		if founded:
			continue
		
		var n = node.instance()
		child_node.add_child(n)
		n.set_position(Vector2.ZERO)
		n.set_character(word[index])
		child_node = n.get_child_node()
		children = child_node.get_children()
	child_node.get_parent().increase_frequency()
	relocate()

func relocate():
	root.relocate(Vector2.ZERO, 0.0, 2 * PI)