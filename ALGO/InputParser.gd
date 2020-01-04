extends Panel

onready var input_text = $VBoxContainer/TextInputContainer/TextInput
onready var process_text = $VBoxContainer/TextInputContainer/TextProcess
onready var feed_button = $VBoxContainer/ButtonContainer/HBoxContainer/Feed

signal feed
signal clear
signal word_parsed
signal parsing_completed

var text_processed: String
var word: String
var text_ready: String
var word_regex: RegEx = RegEx.new()

func _ready():
	word_regex.compile("(\\W*)(\\w+)")
	input_text.set_visible(true)
	input_text.set_text("")
	process_text.set_visible(false)
	process_text.set_use_bbcode(true)
	process_text.set_bbcode("")


func Feed():
	feed_button.set_disabled(true)
	text_ready = input_text.get_text()
	UpdateTextProcessing()
	input_text.set_visible(false)
	process_text.set_visible(true)
	emit_signal("feed")


func Clear():
	feed_button.set_disabled(false)
	text_processed = ""
	word = ""
	text_ready = ""
	input_text.set_text("")
	process_text.set_bbcode("")
	input_text.set_visible(true)
	process_text.set_visible(false)
	emit_signal("clear")


func UpdateTextProcessing():
	process_text.parse_bbcode(
		"[color=gray]"
		+ text_processed
		+ "[/color][color=lime]"
		+ word
		+ "[/color][color=white]"
		+ text_ready
		+ "[/color]"
		)


func ParseWord():
	text_processed += word
	word = ""
	if text_ready.empty():
		emit_signal("parsing_completed")
		return
	
	var result = word_regex.search(text_ready)
	if result == null:
		text_processed += text_ready
		text_ready = ""
		UpdateTextProcessing()
		emit_signal("parsing_completed")
		return
	
	text_processed += result.get_strings()[1]
	word = result.get_strings()[2]
	text_ready = text_ready.substr(result.get_end(), text_ready.length() - result.get_end())
	UpdateTextProcessing()
	emit_signal("word_parsed", word)
