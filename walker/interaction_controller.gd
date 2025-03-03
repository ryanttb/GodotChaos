extends RayCast3D

@onready var interaction_prompt: Label = $InteractionPrompt

func _process(_delta: float) -> void:
	interaction_prompt.text = ""
	
	var object = get_collider()
	if object and object is InteractableObject:
		var interactable_obj: InteractableObject = object
		if not interactable_obj.can_interact:
			return
		
		interaction_prompt.text = "(E) " + interactable_obj.interact_prompt
		
		if Input.is_action_just_pressed("interact"):
			interactable_obj._interact()
