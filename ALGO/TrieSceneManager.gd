extends Control

onready var trie_root = $TrieRoot
onready var input_parser = $InputParser

func _ready():
	trie_root.connect("insert_completed", input_parser, "ParseWord")
	input_parser.connect("word_parsed", trie_root, "insert")
	input_parser.connect("clear", trie_root, "clear")
