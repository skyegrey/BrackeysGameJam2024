class_name BuildingMenu extends HBoxContainer

var hovered_building

@onready var tent = $Tent

# Called when the node enters the scene tree for the first time.
func _ready():
	tent.mouse_entered.connect(_set_hovered_building.bind(tent))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _set_hovered_building(_hovered_building):
	hovered_building = _hovered_building
