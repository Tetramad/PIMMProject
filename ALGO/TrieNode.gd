extends TextureRect

class_name TrieNode

onready var character_label = $VBoxContainer/CharacterLabel
onready var frequency_label = $VBoxContainer/FrequencyLabel
onready var child_node = $ChildNode setget _block_set, get_child_node

const MIN_STEP: float = 5.0

var moving: bool = false setget set_moving, is_moving
var destination: Vector2 = Vector2.ZERO setget set_destination, get_destination
var speed: float = 1.0
var radius: float = 20.0

signal arrived


func _block_set(value):
	push_error("Explicit child nodes setting is blocked")
	assert(false)


func get_child_node():
	return child_node


func set_moving(value: bool):
	moving = value


func is_moving() -> bool:
	return moving


func set_destination(dest: Vector2):
	destination = dest


func get_destination() -> Vector2:
	return destination


func set_character(character: String):
	character_label.set_text(character)


func get_character() -> String:
	return character_label.get_text()


func increase_frequency():
	var freq: int = frequency_label.get_text().to_int()
	frequency_label.set_text(String(freq + 1))


func get_frequency() -> int:
	return frequency_label.get_text().to_int()


func relocate(pivot: Vector2, direction: float, sector_angle: float):
	set_destination(pivot)
	set_moving(true)
	
	var children = get_child_node().get_children()
	var base = direction - sector_angle/2
	for i in range(children.size()):
		var _direction = base + (sector_angle/(children.size() + 1)) * (i + 1)
		var _pivot = 4 * radius * Vector2(cos(_direction), sin(_direction))
		children[i].relocate(_pivot, _direction, max(sector_angle/2, PI/10))


func _process(delta):
	update()


func _physics_process(delta):
	if is_moving():
		var distance = get_position().distance_to(get_destination())
		if distance < MIN_STEP:
			set_moving(false)
			set_position(get_position().linear_interpolate(get_destination(), 1.0))
			emit_signal("arrived", self)
		else:
			set_position(get_position().linear_interpolate(get_destination(), delta * speed))


func _draw():
	var center = get_size()/2
	for child in get_child_node().get_children():
		draw_line(center + center.direction_to(child.get_position()) * radius, child.get_position(), Color.black)



