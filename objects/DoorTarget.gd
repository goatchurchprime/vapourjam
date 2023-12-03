extends Node3D


@export var colourindensitythreshold = 0.4

signal doorcamera_unlocked(doorcameranode)

func _ready():
	get_node("../ViewPanel").get_surface_override_material(0).albedo_texture = get_node("../SubViewport").get_viewport().get_texture()

func scoreviewport():
	get_node("../SubViewport").render_target_update_mode = SubViewport.UPDATE_ONCE
	await RenderingServer.frame_post_draw
	var image: Image = get_node("../SubViewport").get_viewport().get_texture().get_image()
	if image == null:
		return
	var ldooropen = true
	var shrinkhappened = false
	var maxshrinksz = -1.0
	var vpsz = get_node("../SubViewport").size
	for qh in range(2):
		for qw in range(2):
			var x = int(vpsz.x*(0.25 + 0.5*qw))
			var y = int(vpsz.y*(0.25 + 0.5*qh))
			var c = image.get_pixel(x, y)
			var colourintensity = c.get_luminance()
			if qw == 0 and qh == 0 and colourintensity != 0:
				print("lumin00 ", c, colourintensity)
			var qn = get_node("Q%d%d" % [qw, qh])
			if colourintensity > colourindensitythreshold:
				if qn.visible:
					shrinkhappened = true
					var sz = qn.scale.x - 1.0
					if sz == 0.0:
						qn.visible = false
					else:
						qn.scale = Vector3(sz, sz, 4*(1.0 - colourintensity))
						ldooropen = false
					if maxshrinksz == -1.0 or maxshrinksz < sz:
						maxshrinksz = sz
			else:
				var sz = 4 # qn.scale.x + 1.0
				maxshrinksz = 4
				if sz <= 4:
					qn.visible = true
					qn.scale = Vector3(sz, sz, 4*(1.0 - colourintensity))
				ldooropen = false
						
	if not $QExit.visible and ldooropen:
		$QExit.visible = true
		$OpenSound.play()
		emit_signal("doorcamera_unlocked", get_parent())
	elif shrinkhappened and maxshrinksz != -1.0:
		$RingSound.pitch_scale = (maxshrinksz + 1.0)*0.3
		$RingSound.play()
		
			
			
var t0 = 0
func _process(delta):
	t0 += delta
	if t0 > 0.5:
		if not $QExit.visible:
			scoreviewport()
		t0 = 0


func _on_door_camera_action_pressed(pickable):
	print("_on_door_camera_action_pressed ", pickable)
	$QExit.visible = false
	for qh in range(2):
		for qw in range(2):
			var qn = get_node("Q%d%d" % [qw, qh])
			qn.scale = Vector3(4,4,4)
			qn.visible = true
