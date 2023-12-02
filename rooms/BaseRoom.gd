extends Node3D


func _ready():
	var xrorigin = XRHelpers.get_xr_origin(get_parent())
	var xrcamera = XRHelpers.get_xr_camera(get_parent())
	var camera_transform = xrcamera.transform
	var view_direction = camera_transform.basis.z
	view_direction.y = 0
	var transform : Transform3D
	transform = transform.looking_at(-view_direction, Vector3.UP)
	transform.origin = camera_transform.origin
	transform.origin.y = 0
	xrorigin.global_transform = ($SpawnPoint.global_transform * transform.inverse()).orthonormalized()
	print("spawn ", xrcamera.global_transform, $SpawnPoint.global_transform)
