extends Node

class_name ShoppeState

const DEFAULT_DATA := {
	"pins": [0, 0, 0, 0, 0, 0],
	"selected_pin": -1,
	"currency": 0
}

const ShoppePins := [
	"IceBlow",
	"BlownKiss",
	"WonderMagnum",
	"SexyBeam",
	"CasualPendulum",
	"NaturalPuppy"
]

var path := "user://save000.json"

var data := DEFAULT_DATA

func _ready() -> void:
	print("data_dir: ", OS.get_data_dir())
	load_data()
	print_data()

func reset_data() -> void:
	data = DEFAULT_DATA
	save_data()

func pin_to_resource(index: int) -> String:
	var pin_name: String = ShoppePins[index]
	return "res://assets/sprites/pin_" + pin_name.to_snake_case() + ".png"

func print_data() -> void:
	print("pins:")
	for i in range(data["pins"].size()):
		print("  ", ShoppePins[i], ": ", data["pins"][i])
	print("selected_pin: ", data["selected_pin"])
	print("currency: ", data["currency"])

func buy_pin(index: int) -> void:
	data["pins"][index] += 1
	save_data()

func select_pin(index: int) -> void:
	data["selected_pin"] = index
	save_data()

func set_currency(currency) -> void:
	data["currency"] = currency
	save_data()
	
func save_data() -> void:
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file:
		var game_data := { "data": data }
		file.store_var(game_data)
		file.close()
	else:
		print("Global save_data open_error: ", FileAccess.get_open_error())

func load_data() -> void:
	var file := FileAccess.open(path, FileAccess.READ)
	if file:
		var game_data: Variant = file.get_var()
		data = game_data["data"]
		file.close()
	else:
		print("Global load_data open_error: ", FileAccess.get_open_error())
