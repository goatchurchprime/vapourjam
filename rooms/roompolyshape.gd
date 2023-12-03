extends StaticBody3D


# Called when the node enters the scene tree for the first time.
func _ready():
	var facets = $room_poly/room_8gon.mesh.get_faces()
	facets = $room_poly.transform*$room_poly/room_8gon.transform*facets
	$CollisionShape3D.shape.set_faces(facets)

