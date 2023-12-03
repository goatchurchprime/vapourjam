extends Node3D

func moveplayertospawnpoint():
	var xrorigin = XRHelpers.get_xr_origin(get_parent())
	if xrorigin:
		var xrcamera = XRHelpers.get_xr_camera(get_parent())
		var camera_transform = xrcamera.transform
		var view_direction = camera_transform.basis.z
		view_direction.y = 0
		var transform : Transform3D
		transform = transform.looking_at(-view_direction, Vector3.UP)
		transform.origin = camera_transform.origin
		transform.origin.y = 0
		xrorigin.global_transform = ($SpawnPoint.global_transform * transform.inverse()).orthonormalized()
		#print("spawn ", xrcamera.global_transform, $SpawnPoint.global_transform)

var doorcamerasremaining = [ ]
func _ready():
	moveplayertospawnpoint()
	for doorcamera in $DoorCameras.get_children():
		doorcamera.get_node("Quarters").doorcamera_unlocked.connect(on_doorcamera_unlocked)
		doorcamerasremaining.append(doorcamera)
	$ExitDoor/XRToolsInteractableAreaButton.button_pressed.connect(get_parent().currentsceneexited)

func activateexitdoor():
	$ExitDoor/XRToolsInteractableAreaButton.monitoring = true
	$ExitDoor/XRToolsInteractableAreaButton/FrameMesh.visible = true

func on_doorcamera_unlocked(doorcamera):
	doorcamerasremaining.erase(doorcamera)
	if len(doorcamerasremaining) == 0:
		activateexitdoor()
