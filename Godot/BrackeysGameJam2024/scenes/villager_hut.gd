class_name VillagerHut extends Building

# Is there a way to make these comments in the file by default?

# Scene refs
@onready var new_villager_spawn_timer = $NewVillagerSpawnTimer
@onready var progress_bar = $ProgressBar

# Signals
signal spawn_new_villager

# Called when the node enters the scene tree for the first time.
func _ready():
	new_villager_spawn_timer.timeout.connect(_spawn_new_villager)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_update_progress_bar()

func _spawn_new_villager():
	spawn_new_villager.emit(self)

func _update_progress_bar():
	progress_bar.value = (new_villager_spawn_timer.wait_time - new_villager_spawn_timer.time_left) / new_villager_spawn_timer.wait_time
