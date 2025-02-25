extends Node

class_name ShoppeMainNode

@export var pin_sprites: Array[Texture]
@export var select_style: StyleBoxFlat

var buy_buttons: Array[Node]

func _ready() -> void:
	($Shiki as ShikiNode).set_tap_bounds($WalkingArea.get_global_rect())
	
	buy_buttons = get_tree().get_nodes_in_group("BuyButtons")
	
	connect_signals()
	
	update_buttons()
	
	if Global.data["selected_pin"] != -1:
		select_pin(Global.data["selected_pin"])
	
	$ShoppeWindow/CurrencyLabel.text = str_separated(Global.data["currency"])
	if $ShoppeWindow.visible:
		$ShoppeUI/HBoxContainer/ShopButton.text = "Exit"

func _on_shop_button_pressed() -> void:
	$ShoppeWindow.visible = !$ShoppeWindow.visible
	$ShoppeUI/HBoxContainer/ShopButton.text = "Exit" if $ShoppeWindow.visible else "Shop"

func _on_shoppe_window_close_requested() -> void:
	$ShoppeWindow.hide()
	$ShoppeUI/HBoxContainer/ShopButton.text = "Shop"

func _on_currency_button_pressed() -> void:
	set_currency(Global.data["currency"] + 1000)

func _on_buy_button_pressed(button: Button, index: int) -> void:
	print("ShoppeMain on_buy_button_pressed button: ", button.text, ", index: ", index)
	if not button.disabled:
		if button.text == "Owned":
			select_pin(index)
		else:
			var item_price = int(button.text.replace(",", ""))
			print("  price: ", item_price)
			if Global.data["currency"] >= item_price:
				set_currency(Global.data["currency"] - item_price)
				Global.buy_pin(index)
				if Global.data["selected_pin"] == -1:
					select_pin(index)
				Global.print_data()
			else:
				$ShoppeWindow/NotEnough.show()
		update_buttons()
	else:
		print("  already have")

func connect_signals() -> void:
	for index in buy_buttons.size():
		buy_buttons[index].connect("pressed", _on_buy_button_pressed.bind(buy_buttons[index], index))

func set_currency(new_currency) -> void:
	Global.set_currency(new_currency)
	$ShoppeWindow/CurrencyLabel.text = str_separated(Global.data["currency"])

func select_pin(index: int) -> void:
	Global.select_pin(index)
	
	#var pin_resource := Global.pin_to_resource(index)
	#%SelectedPin.set_texture(load(pin_resource))
	%SelectedPin.set_texture(pin_sprites[index])
	%SelectedPin.modulate = Color.WHITE
	
func str_separated(input_number : int) -> String:
	var number_as_string := str(input_number)
	var output_string := ""
	var last_index := number_as_string.length() - 1
	# for each digit in the number...
	for index in range(number_as_string.length()):
		# add that digit to the output string, and then...
		output_string = output_string + number_as_string.substr(index, 1)
		# if the index is at the thousandths, millions, billionths place, etc.
		# i.e. where you would put a comma, then insert a comma after that digit.
		if (last_index - index) % 3 == 0 and index != last_index:
			output_string = output_string + ","
	return output_string

func update_buttons() -> void:
	for index in buy_buttons.size():
		var button := buy_buttons[index] as Button
		if index == Global.data["selected_pin"]:
			button.disabled = true
			button.text = "Selected"
			button.remove_theme_stylebox_override("normal")
			button.remove_theme_stylebox_override("hover")
			button.remove_theme_stylebox_override("pressed")
		elif Global.data["pins"][index] > 0:
			button.disabled = false
			button.text = "Owned"
			button.add_theme_stylebox_override("normal", select_style)
			button.add_theme_stylebox_override("hover", select_style)
			button.add_theme_stylebox_override("pressed", select_style)

func _on_reset_data_button_pressed() -> void:
	Global.reset_data()
	get_tree().reload_current_scene()
