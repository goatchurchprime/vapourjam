extends Node3D

@onready var current_scene = $Level1

func currentsceneexited(button):
	load_scene("res://rooms/Level3.tscn")

func set_fade(p_value : float):
	if p_value == 0.0:
		$Fade.visible = false
	else:
		$Fade.get_surface_override_material(0).set_shader_parameter("alpha", p_value)
		$Fade.visible = true

var _tween : Tween
func load_scene(p_scene_path : String):
	if current_scene:
		if _tween:
			_tween.kill()
		_tween = get_tree().create_tween()
		_tween.tween_method(set_fade, 0.0, 1.0, 0.15)
		await _tween.finished
		remove_child(current_scene)
		current_scene.queue_free()
		current_scene = null

	# Load the new scene
	var new_scene : PackedScene
	if ResourceLoader.has_cached(p_scene_path):
		new_scene = ResourceLoader.load(p_scene_path)
	else:
		ResourceLoader.load_threaded_request(p_scene_path)
		var res : ResourceLoader.ThreadLoadStatus
		while true:
			var progress := []
			res = ResourceLoader.load_threaded_get_status(p_scene_path, progress)
			if res != ResourceLoader.THREAD_LOAD_IN_PROGRESS:
				break;
			await get_tree().create_timer(0.1).timeout

		if res != ResourceLoader.THREAD_LOAD_LOADED:
			push_error("Error ", res, " loading resource ", p_scene_path)
			breakpoint
			get_tree().quit(1)
		new_scene = ResourceLoader.load_threaded_get(p_scene_path)

	current_scene = new_scene.instantiate()
	add_child(current_scene)

	await get_tree().create_timer(0.1).timeout
	if _tween:
		_tween.kill()
	_tween = get_tree().create_tween()
	_tween.tween_method(set_fade, 1.0, 0.0, 1.0)
	await _tween.finished

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_O:
			current_scene.activateexitdoor()
			#load_scene("res://rooms/Level2.tscn")
			
			
