extends StaticBody3D


@export var collisionmeshname = "octogonroom/room_8gon_003"
# Called when the node enters the scene tree for the first time.
func _ready():
	var collisionmesh = get_node("octogonroom/room_8gon_003")
	var facets = collisionmesh.mesh.get_faces()
	facets = global_transform.inverse()*collisionmesh.global_transform*facets
	$CollisionShape3D.shape.set_faces(facets)

