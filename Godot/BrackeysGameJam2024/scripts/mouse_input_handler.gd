class_name MouseInputHandler extends Node

# Children refernces
@onready var drag_panel = $Panel

# State variables
@onready var is_dragging: bool = false
@onready var drag_starting_position: Vector2
@onready var last_drag_position: Vector2

signal mouse_drag_started
signal mouse_drag_finished
signal mouse_right_clicked

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			mouse_right_clicked.emit(_adjust_event_position_for_window_size(event.position))
		elif event.pressed:
			_start_mouse_drag(_adjust_event_position_for_window_size(event.position))
		else:
			_end_mouse_drag()
	elif is_dragging and event is InputEventMouseMotion:
		_update_mouse_drag(_adjust_event_position_for_window_size(event.position))

func _adjust_event_position_for_window_size(event_position):
	return event_position - Vector2(get_viewport().size/2)

func _start_mouse_drag(position):
	mouse_drag_started.emit()
	drag_panel.visible = true
	is_dragging = true
	drag_starting_position = position
	drag_panel.position = drag_starting_position

func _end_mouse_drag():
	is_dragging = false
	drag_panel.visible = false
	mouse_drag_finished.emit(
		Rect2(
			drag_panel.position,
			drag_panel.size
		)
	)
	drag_panel.size = Vector2.ZERO

func _update_mouse_drag(position):
	if position.x < drag_starting_position.x:
		drag_panel.position.x = position.x
	if position.y < drag_starting_position.y:
		drag_panel.position.y = position.y
	drag_panel.size = abs(drag_starting_position - position)
	last_drag_position = position
