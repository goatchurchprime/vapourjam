extends Node3D




var sang = 0.0
func _process(delta):
	sang = (sang + delta*1)
	sang = sang - int(sang)
	rotation_degrees.z = sang*90
	$BladeX.scale.y = Vector2(1, tan(deg_to_rad(min(rotation_degrees.z, 90 - rotation_degrees.z)))).length()
	$BladeY.scale.y = Vector2(1, tan(deg_to_rad(min(rotation_degrees.z, 90 - rotation_degrees.z)))).length()
