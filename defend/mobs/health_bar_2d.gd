class_name HealthBar
extends ProgressBar

func init(amount: int) -> void:
	max_value = amount
	value = amount

func update(amount: int) -> void:
	value = amount
