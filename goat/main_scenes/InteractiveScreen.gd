extends StaticBody

export (String) var unique_name
export (Vector2) var content_size = Vector2(100, 100)

onready var screen_surface = $ScreenSurface
onready var viewport = $Viewport
onready var content = get_node("Content")


func _ready():
	add_to_group("goat_interactive_item_" + unique_name)
	goat.register_unique_name(unique_name)
	remove_child(content)
	viewport.add_child(content)
	screen_surface.material_override = screen_surface.material_override.duplicate(true)
	screen_surface.material_override.albedo_texture = viewport.get_texture()
	# warning-ignore:return_value_discarded
	goat.connect("interactive_item_activated", self, "activate")
	content.rect_size = content_size
	viewport.size = content_size


func activate(item_name, position):
	if item_name != unique_name:
		return
	var local_position = screen_surface.to_local(position)
	var screen_coordinates = Vector2(local_position.x + 0.5, 0.5 - local_position.y) * viewport.size
	var ev = InputEventMouseButton.new()
	ev.button_index = BUTTON_LEFT
	ev.global_position = screen_coordinates
	ev.position = screen_coordinates
	# Press the button
	ev.pressed = true
	ev.button_mask = 1
	viewport.input(ev)
	# Release the button
	ev.pressed = false
	ev.button_mask = 0
	viewport.input(ev)


func is_inventory_item():
	return false
