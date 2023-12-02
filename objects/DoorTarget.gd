extends Node3D


const alphameasure = 0.7

func _ready():
	print(get_node("../ViewPanel").get_surface_override_material(0).albedo_texture.viewport_path)
	print(get_node("/root/Main").get_path_to(get_node("../SubViewport")))
	get_node("../ViewPanel").get_surface_override_material(0).albedo_texture = get_node("../SubViewport").get_viewport().get_texture()
	#get_node("../ViewPanel").get_surface_override_material(0).albedo_texture.viewport_path = get_node("/root/Main").get_path_to(get_node("../SubViewport"))
	print("l ", get_node("/root/Main").get_path_to(get_node("../SubViewport")))

func scoreviewport():
	get_node("../SubViewport").render_target_update_mode = SubViewport.UPDATE_ONCE
	await RenderingServer.frame_post_draw
	var image: Image = get_node("../SubViewport").get_viewport().get_texture().get_image()
	var ldooropen = true
	for qh in range(2):
		for qw in range(2):
			var x = qw*8 + 3
			var y = qh*8 + 3
			var c = image.get_pixel(x, y)
			var qn = get_node("Q%d%d" % [qw, qh])
			if c.a > alphameasure:
				if qn.visible:
					var sz = qn.scale.x - 1.0
					if sz == 0.0:
						qn.visible = false
					else:
						qn.scale = Vector3(sz, sz, sz)
						ldooropen = false
			else:
				var sz = 4 # qn.scale.x + 1.0
				if sz <= 4:
					qn.visible = true
					qn.scale = Vector3(sz, sz, sz)
				ldooropen = false
						
	$QExit.visible = ldooropen
			
			
var t0 = 0
func _process(delta):
	t0 += delta
	if t0 > 1.0:
		if not $QExit.visible:
			scoreviewport()
		t0 = 0

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_P:
			get_node("../../GPUVapourSource2").position.x += 0.1


func _on_door_camera_action_pressed(pickable):
	print("_on_door_camera_action_pressed ", pickable)
	$QExit.visible = false
	for qh in range(2):
		for qw in range(2):
			var qn = get_node("Q%d%d" % [qw, qh])
			qn.scale = Vector3(4,4,4)
			qn.visible = true
