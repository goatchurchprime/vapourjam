extends Node3D


var sceneorder = [ "TheLobby", "InvisibleParticles", "EasyIntro", "FocusSphere" ]
var currentsceneindex = 0
var current_scene = null

func preparecurrentscene():
	if currentsceneindex == 0:
		await get_tree().create_timer(0.1).timeout
		current_scene.activateexitdoor()

func _ready():
	current_scene = get_node(sceneorder[currentsceneindex])
	assert (current_scene != null)
	preparecurrentscene()
	
func currentsceneexited(button):
	await fadeoutcurrentscene()
	currentsceneindex += 1
	if currentsceneindex >= len(sceneorder):
		currentsceneindex = 0
	loadnewcurrentscene("res://rooms/%s.tscn" % sceneorder[currentsceneindex])
	preparecurrentscene()
	

func set_fade(p_value : float):
	if p_value == 0.0:
		$Fade.visible = false
	else:
		$Fade.get_surface_override_material(0).set_shader_parameter("alpha", p_value)
		$Fade.visible = true

var _tween : Tween
func fadeoutcurrentscene():
	if _tween:
		_tween.kill()
	_tween = get_tree().create_tween()
	_tween.tween_method(set_fade, 0.0, 1.0, 0.25)
	await _tween.finished
	remove_child(current_scene)
	current_scene.queue_free()
	current_scene = null

func loadnewcurrentscene(p_scene_path : String):
	print("Loading scene ", p_scene_path)
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
			
			
