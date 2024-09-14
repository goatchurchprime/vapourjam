extends Node3D

@onready var NetworkGateway = get_node("/root/Main/ViewportNetworkGateway/Viewport/NetworkGateway")

func _ready():
	$XRToolsInteractableAreaButton/FrameMesh.visible = not NetworkGateway.is_disconnected()

func _on_xr_tools_interactable_area_button_button_pressed(button):
	if NetworkGateway.is_disconnected():
		NetworkGateway.simple_webrtc_connect("wirralsmoke")
		$XRToolsInteractableAreaButton/FrameMesh.visible = true
		$XRToolsInteractableAreaButton/ButtonMesh/Label3D.text = "!!!On!!!d"
		
