extends Node

signal reset_globals

var Players = {}
var color

signal resources_changed(new_resources)

var resources: Dictionary[String, int] = {
	"Materials": 12,
	"Funds": 12,
	"Radiance": 12,
	"Blight": 12,
	}

var rng = RandomNumberGenerator.new()
var energy_quota: int = 10
var current_energy: int = 0:
	set(value):
		current_energy = value
		energy_changed.emit(current_energy)
		if energy_quota <= current_energy:
			quota_reached.emit()

signal energy_changed
signal quota_reached

func _ready() -> void:
	reset_globals.connect(reset)

func reset() -> void:
	if resources_changed.has_connections(): Helpers.disconnect_all(resources_changed)
	if energy_changed.has_connections(): Helpers.disconnect_all(energy_changed)
	if quota_reached.has_connections(): Helpers.disconnect_all(quota_reached)
	resources = {
		"Materials": 12,
		"Funds": 12,
		"Radiance": 12,
		"Blight": 12,
		}
	rng = RandomNumberGenerator.new()
	current_energy = 0
