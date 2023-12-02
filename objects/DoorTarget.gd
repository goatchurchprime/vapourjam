extends Node3D


const alphameasure = 0.7

func _ready():
	get_node("../ViewPanel").get_surface_override_material(0).albedo_texture = get_node("../SubViewport").get_viewport().get_texture()

func scoreviewport():
	get_node("../SubViewport").render_target_update_mode = SubViewport.UPDATE_ONCE
	await RenderingServer.frame_post_draw
	var image: Image = get_node("../SubViewport").get_viewport().get_texture().get_image()
	var ldooropen = true
	var vpsz = get_node("../SubViewport").size
	for qh in range(2):
		for qw in range(2):
			var x = int(vpsz.x*(0.25 + 0.5*qw))
			var y = int(vpsz.y*(0.25 + 0.5*qh))
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
