extends Node

var current_scene: Node = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var root: Window = get_tree().root
	current_scene = root.get_child(-1)
	print("AutoloadGlobal _ready current_scene.name: ", current_scene.name)

func _deferred_goto_scene(path):
	# now safe to remove old scene (deferred)
	current_scene.free()
	
	# load new scene
	var scene: PackedScene = ResourceLoader.load(path)
	
	# instance new scene
	current_scene = scene.instantiate()
	
	# add to active scene (as child of root)
	# scene  singleton
	#      \/
	#     root
	#      ||
	# current_scene
	get_tree().root.add_child(current_scene)
	
	# optional, make it compatible with SceneTree.change_scene_to_file
	get_tree().current_scene = current_scene

func goto_scene(path):
	# defer in case current scene is still processing
	_deferred_goto_scene.call_deferred(path)
