extends Node3D

func _ready():
	print(get_node("../ViewPanel").get_surface_override_material(0).albedo_texture.viewport_path)
	print(get_node("/root/Main").get_path_to(get_node("../SubViewport")))
	get_node("../ViewPanel").get_surface_override_material(0).albedo_texture.viewport_path = get_node("/root/Main").get_path_to(get_node("../SubViewport"))

func scoreviewport():
	get_node("../SubViewport").render_target_update_mode = SubViewport.UPDATE_ONCE
	await RenderingServer.frame_post_draw
	var image: Image = get_node("../SubViewport").get_viewport().get_texture().get_image()
	print(image.get_pixel(7, 7))
	for qh in range(2):
		for qw in range(2):
			var x = qw*8 + 3
			var y = qh*8 + 3
			var c = image.get_pixel(x, y)
			get_node("Q%d%d" % [qw, qh]).visible = (c.a > 0.5)
			
			
var t0 = 0
func _process(delta):
	t0 += delta
	if t0 > 1.0:
		scoreviewport()
		t0 = 0

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_P:
			get_node("../../GPUVapourSource2").position.x += 0.1
