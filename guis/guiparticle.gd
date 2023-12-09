extends Control

var vbsetget = [ ]
@export var isgpuemitter = true

var gpuparticles3d = null
func vchanged(value, vb, hsetter):
	print("vchanged ", value, " ", vb, " ", hsetter)
	if gpuparticles3d != null:
		gpuparticles3d.call(hsetter, value)
		
func PropertyInfo(t, s, hint=-1, hintdef=""):
	return [t, s, hint, hintdef]
func ADD_PROPERTY(k, hsetter, hgetter):
	var lab = Label.new()
	lab.text = k[1].capitalize()
	var hint = k[2]
	var hintdef = k[3].split(",")
	$GridContainer.add_child(lab)
	var vb = null
	var cbgetter = ""
	if k[0] == "Variant::BOOL":
		vb = CheckBox.new()
		vb.text = "On"
		cbgetter = "set_pressed"
		vb.toggled.connect(vchanged.bind(vb, hsetter))
	elif k[0] == "Variant::INT" and hint == PROPERTY_HINT_ENUM:
		vb = OptionButton.new()
		for hd in hintdef:
			vb.add_item(hd)
		cbgetter = "_select_int"
		vb.item_selected.connect(vchanged.bind(vb, hsetter))
	elif k[0] == "Variant::INT" or k[0] == "Variant::FLOAT":
		vb = SpinBox.new()
		vb.value = 1
		vb.min_value = float(hintdef[0])
		vb.max_value = float(hintdef[1])
		vb.step = float(hintdef[2])
		cbgetter = "set_value"
		vb.value_changed.connect(vchanged.bind(vb, hsetter))
	$GridContainer.add_child(vb)
	vbsetget.append([vb, hsetter, hgetter, cbgetter])


func setdestthing(lgpuparticles3d):
	for x in vbsetget:
		var val = lgpuparticles3d.call(x[2])
		x[0].call(x[3], val)
	gpuparticles3d = lgpuparticles3d
	

func makeguiparticle():
	ADD_PROPERTY(PropertyInfo("Variant::INT", "draw_order", PROPERTY_HINT_ENUM, "Index,Lifetime,Reverse Lifetime,View Depth"), "set_draw_order", "get_draw_order");
	ADD_PROPERTY(PropertyInfo("Variant::BOOL", "emitting"), "set_emitting", "is_emitting")
	ADD_PROPERTY(PropertyInfo("Variant::INT", "amount", PROPERTY_HINT_RANGE, "1,1000000,1,exp"), "set_amount", "get_amount")
	ADD_PROPERTY(PropertyInfo("Variant::FLOAT", "amount_ratio", PROPERTY_HINT_RANGE, "0,1,0.0001"), "set_amount_ratio", "get_amount_ratio");
	ADD_PROPERTY(PropertyInfo("Variant::FLOAT", "lifetime", PROPERTY_HINT_RANGE, "0.01,600.0,0.01,or_greater,exp,suffix:s"), "set_lifetime", "get_lifetime");
	ADD_PROPERTY(PropertyInfo("Variant::FLOAT", "interp_to_end", PROPERTY_HINT_RANGE, "0.00,1.0,0.01"), "set_interp_to_end", "get_interp_to_end");
	ADD_PROPERTY(PropertyInfo("Variant::BOOL", "one_shot"), "set_one_shot", "get_one_shot");
	#ADD_PROPERTY(PropertyInfo("Variant::FLOAT", "preprocess", PROPERTY_HINT_RANGE, "0.00,600.0,0.01,exp,suffix:s"), "set_pre_process_time", "get_pre_process_time");
	ADD_PROPERTY(PropertyInfo("Variant::FLOAT", "speed_scale", PROPERTY_HINT_RANGE, "0,64,0.01"), "set_speed_scale", "get_speed_scale");
	ADD_PROPERTY(PropertyInfo("Variant::FLOAT", "explosiveness", PROPERTY_HINT_RANGE, "0,1,0.01"), "set_explosiveness_ratio", "get_explosiveness_ratio");
	ADD_PROPERTY(PropertyInfo("Variant::FLOAT", "randomness", PROPERTY_HINT_RANGE, "0,1,0.01"), "set_randomness_ratio", "get_randomness_ratio");
	ADD_PROPERTY(PropertyInfo("Variant::INT", "fixed_fps", PROPERTY_HINT_RANGE, "0,1000,1,suffix:FPS"), "set_fixed_fps", "get_fixed_fps");
	ADD_PROPERTY(PropertyInfo("Variant::BOOL", "interpolate"), "set_interpolate", "get_interpolate");
	ADD_PROPERTY(PropertyInfo("Variant::BOOL", "fract_delta"), "set_fractional_delta", "get_fractional_delta");
	ADD_PROPERTY(PropertyInfo("Variant::FLOAT", "collision_base_size", PROPERTY_HINT_RANGE, "0,128,0.01,or_greater,suffix:m"), "set_collision_base_size", "get_collision_base_size");
	ADD_PROPERTY(PropertyInfo("Variant::BOOL", "local_coords"), "set_use_local_coordinates", "get_use_local_coordinates");
	ADD_PROPERTY(PropertyInfo("Variant::INT", "draw_order", PROPERTY_HINT_ENUM, "Index,Lifetime,Reverse Lifetime,View Depth"), "set_draw_order", "get_draw_order");
	ADD_PROPERTY(PropertyInfo("Variant::INT", "transform_align", PROPERTY_HINT_ENUM, "Disabled,Z-Billboard,Y to Velocity,Z-Billboard + Y to Velocity"), "set_transform_align", "get_transform_align");

func makeguiparticlematerial():
	ADD_PROPERTY(PropertyInfo("Variant::INT", "emission_shape", PROPERTY_HINT_ENUM, "Point,Sphere,Sphere Surface,Box,Points,Directed Points,Ring"), "set_emission_shape", "get_emission_shape");
	ADD_PROPERTY(PropertyInfo("Variant::FLOAT", "emission_sphere_radius", PROPERTY_HINT_RANGE, "0.01,128,0.01,or_greater"), "set_emission_sphere_radius", "get_emission_sphere_radius");
	ADD_PROPERTY(PropertyInfo("Variant::FLOAT", "inherit_velocity_ratio", PROPERTY_HINT_RANGE, "0.0,1.0,0.001,or_less,or_greater"), "set_inherit_velocity_ratio", "get_inherit_velocity_ratio");
	ADD_PROPERTY(PropertyInfo("Variant::FLOAT", "spread", PROPERTY_HINT_RANGE, "0,180,0.001"), "set_spread", "get_spread");
	ADD_PROPERTY(PropertyInfo("Variant::FLOAT", "flatness", PROPERTY_HINT_RANGE, "0,1,0.001"), "set_flatness", "get_flatness");
	#ADD_PROPERTY(PropertyInfo("Variant::FLOAT", "initial_velocity_min", PROPERTY_HINT_RANGE, "0,1000,0.01,or_less,or_greater"), "set_param_min", "get_param_min");
	#EaaADD_PROPERTY(PropertyInfo("Variant::FLOAT", "initial_velocity_max", PROPERTY_HINT_RANGE, "0,1000,0.01,or_less,or_greater"), "set_param_max", "get_param_max");
	ADD_PROPERTY(PropertyInfo("Variant::BOOL", "turbulence_enabled"), "set_turbulence_enabled", "get_turbulence_enabled");
	ADD_PROPERTY(PropertyInfo("Variant::FLOAT", "turbulence_noise_strength", PROPERTY_HINT_RANGE, "0,20,0.01"), "set_turbulence_noise_strength", "get_turbulence_noise_strength");
	ADD_PROPERTY(PropertyInfo("Variant::FLOAT", "turbulence_noise_scale", PROPERTY_HINT_RANGE, "0,10,0.001,or_greater"), "set_turbulence_noise_scale", "get_turbulence_noise_scale");
	ADD_PROPERTY(PropertyInfo("Variant::FLOAT", "turbulence_noise_speed_rnd", PROPERTY_HINT_RANGE, "0,4,0.01"), "set_turbulence_noise_speed_random", "get_turbulence_noise_speed_random");

# this would need to be implemented as a value setting, not a function call
	#ADD_PROPERTY(PropertyInfo("Variant::FLOAT", "turbulence_influence_min", PROPERTY_HINT_RANGE, "0,1,0.001"), "set_param_min", "get_param_min");
	#ADD_PROPERTY(PropertyInfo("Variant::FLOAT", "turbulence_influence_max", PROPERTY_HINT_RANGE, "0,1,0.001"), "set_param_max", "get_param_max");

	
func _ready():
	isgpuemitter = not get_node_or_null("../..").name.ends_with("material")
	var lgpuparticles3d = get_node_or_null("../../../VapourSource/GPUParticles3D")
	if lgpuparticles3d:
		if isgpuemitter:
			makeguiparticle()
			setdestthing(lgpuparticles3d)
			gpuparticles3d = lgpuparticles3d
		else:
			makeguiparticlematerial()
			setdestthing(lgpuparticles3d.process_material)
			gpuparticles3d = lgpuparticles3d.process_material
	

"""
from gpu_particles_3d.cpp
	ADD_PROPERTY(PropertyInfo(Variant::BOOL, "emitting"), "set_emitting", "is_emitting");
	ADD_PROPERTY_DEFAULT("emitting", true); // Workaround for doctool in headless mode, as dummy rasterizer always returns false.
	ADD_PROPERTY(PropertyInfo(Variant::INT, "amount", PROPERTY_HINT_RANGE, "1,1000000,1,exp"), "set_amount", "get_amount");
	ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "amount_ratio", PROPERTY_HINT_RANGE, "0,1,0.0001"), "set_amount_ratio", "get_amount_ratio");
	ADD_PROPERTY(PropertyInfo(Variant::NODE_PATH, "sub_emitter", PROPERTY_HINT_NODE_PATH_VALID_TYPES, "GPUParticles3D"), "set_sub_emitter", "get_sub_emitter");
	ADD_GROUP("Time", "");
	ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "lifetime", PROPERTY_HINT_RANGE, "0.01,600.0,0.01,or_greater,exp,suffix:s"), "set_lifetime", "get_lifetime");
	ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "interp_to_end", PROPERTY_HINT_RANGE, "0.00,1.0,0.01"), "set_interp_to_end", "get_interp_to_end");
	ADD_PROPERTY(PropertyInfo(Variant::BOOL, "one_shot"), "set_one_shot", "get_one_shot");
	ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "preprocess", PROPERTY_HINT_RANGE, "0.00,600.0,0.01,exp,suffix:s"), "set_pre_process_time", "get_pre_process_time");
	ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "speed_scale", PROPERTY_HINT_RANGE, "0,64,0.01"), "set_speed_scale", "get_speed_scale");
	ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "explosiveness", PROPERTY_HINT_RANGE, "0,1,0.01"), "set_explosiveness_ratio", "get_explosiveness_ratio");
	ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "randomness", PROPERTY_HINT_RANGE, "0,1,0.01"), "set_randomness_ratio", "get_randomness_ratio");
	ADD_PROPERTY(PropertyInfo(Variant::INT, "fixed_fps", PROPERTY_HINT_RANGE, "0,1000,1,suffix:FPS"), "set_fixed_fps", "get_fixed_fps");
	ADD_PROPERTY(PropertyInfo(Variant::BOOL, "interpolate"), "set_interpolate", "get_interpolate");
	ADD_PROPERTY(PropertyInfo(Variant::BOOL, "fract_delta"), "set_fractional_delta", "get_fractional_delta");
	ADD_GROUP("Collision", "collision_");
	ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "collision_base_size", PROPERTY_HINT_RANGE, "0,128,0.01,or_greater,suffix:m"), "set_collision_base_size", "get_collision_base_size");
	ADD_GROUP("Drawing", "");
	ADD_PROPERTY(PropertyInfo(Variant::AABB, "visibility_aabb", PROPERTY_HINT_NONE, "suffix:m"), "set_visibility_aabb", "get_visibility_aabb");
	ADD_PROPERTY(PropertyInfo(Variant::BOOL, "local_coords"), "set_use_local_coordinates", "get_use_local_coordinates");
	ADD_PROPERTY(PropertyInfo(Variant::INT, "draw_order", PROPERTY_HINT_ENUM, "Index,Lifetime,Reverse Lifetime,View Depth"), "set_draw_order", "get_draw_order");
	ADD_PROPERTY(PropertyInfo(Variant::INT, "transform_align", PROPERTY_HINT_ENUM, "Disabled,Z-Billboard,Y to Velocity,Z-Billboard + Y to Velocity"), "set_transform_align", "get_transform_align");
	ADD_GROUP("Trails", "trail_");
	ADD_PROPERTY(PropertyInfo(Variant::BOOL, "trail_enabled"), "set_trail_enabled", "is_trail_enabled");
	ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "trail_lifetime", PROPERTY_HINT_RANGE, "0.01,10,0.01,or_greater,suffix:s"), "set_trail_lifetime", "get_trail_lifetime");
	ADD_GROUP("Process Material", "");
	ADD_PROPERTY(PropertyInfo(Variant::OBJECT, "process_material", PROPERTY_HINT_RESOURCE_TYPE, "ShaderMaterial,ParticleProcessMaterial"), "set_process_material", "get_process_material");
	ADD_GROUP("Draw Passes", "draw_");
	ADD_PROPERTY(PropertyInfo(Variant::INT, "draw_passes", PROPERTY_HINT_RANGE, "0," + itos(MAX_DRAW_PASSES) + ",1"), "set_draw_passes", "get_draw_passes");
	for (int i = 0; i < MAX_DRAW_PASSES; i++) {
		ADD_PROPERTYI(PropertyInfo(Variant::OBJECT, "draw_pass_" + itos(i + 1), PROPERTY_HINT_RESOURCE_TYPE, "Mesh"), "set_draw_pass_mesh", "get_draw_pass_mesh", i);
	}
	ADD_PROPERTY(PropertyInfo(Variant::OBJECT, "draw_skin", PROPERTY_HINT_RESOURCE_TYPE, "Skin"), "set_skin", "get_skin");
"""


"""
	ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "lifetime_randomness", PROPERTY_HINT_RANGE, "0,1,0.01"), "set_lifetime_randomness", "get_lifetime_randomness");
	ADD_GROUP("Particle Flags", "particle_flag_");
	ADD_PROPERTYI(PropertyInfo(Variant::BOOL, "particle_flag_align_y"), "set_particle_flag", "get_particle_flag", PARTICLE_FLAG_ALIGN_Y_TO_VELOCITY);
	ADD_PROPERTYI(PropertyInfo(Variant::BOOL, "particle_flag_rotate_y"), "set_particle_flag", "get_particle_flag", PARTICLE_FLAG_ROTATE_Y);
	ADD_PROPERTYI(PropertyInfo(Variant::BOOL, "particle_flag_disable_z"), "set_particle_flag", "get_particle_flag", PARTICLE_FLAG_DISABLE_Z);
	ADD_PROPERTYI(PropertyInfo(Variant::BOOL, "particle_flag_damping_as_friction"), "set_particle_flag", "get_particle_flag", PARTICLE_FLAG_DAMPING_AS_FRICTION);
	ADD_GROUP("Spawn", "");
	ADD_SUBGROUP("Position", "");
	ADD_PROPERTY(PropertyInfo(Variant::VECTOR3, "emission_shape_offset"), "set_emission_shape_offset", "get_emission_shape_offset");
	ADD_PROPERTY(PropertyInfo(Variant::VECTOR3, "emission_shape_scale"), "set_emission_shape_scale", "get_emission_shape_scale");
	ADD_PROPERTY(PropertyInfo(Variant::INT, "emission_shape", PROPERTY_HINT_ENUM, "Point,Sphere,Sphere Surface,Box,Points,Directed Points,Ring"), "set_emission_shape", "get_emission_shape");
	ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "emission_sphere_radius", PROPERTY_HINT_RANGE, "0.01,128,0.01,or_greater"), "set_emission_sphere_radius", "get_emission_sphere_radius");
	ADD_PROPERTY(PropertyInfo(Variant::VECTOR3, "emission_box_extents"), "set_emission_box_extents", "get_emission_box_extents");
	ADD_PROPERTY(PropertyInfo(Variant::OBJECT, "emission_point_texture", PROPERTY_HINT_RESOURCE_TYPE, "Texture2D"), "set_emission_point_texture", "get_emission_point_texture");
	ADD_PROPERTY(PropertyInfo(Variant::OBJECT, "emission_normal_texture", PROPERTY_HINT_RESOURCE_TYPE, "Texture2D"), "set_emission_normal_texture", "get_emission_normal_texture");
	ADD_PROPERTY(PropertyInfo(Variant::OBJECT, "emission_color_texture", PROPERTY_HINT_RESOURCE_TYPE, "Texture2D"), "set_emission_color_texture", "get_emission_color_texture");
	ADD_PROPERTY(PropertyInfo(Variant::INT, "emission_point_count", PROPERTY_HINT_RANGE, "0,1000000,1"), "set_emission_point_count", "get_emission_point_count");
	ADD_PROPERTY(PropertyInfo(Variant::VECTOR3, "emission_ring_axis"), "set_emission_ring_axis", "get_emission_ring_axis");
	ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "emission_ring_height"), "set_emission_ring_height", "get_emission_ring_height");
	ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "emission_ring_radius"), "set_emission_ring_radius", "get_emission_ring_radius");
	ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "emission_ring_inner_radius"), "set_emission_ring_inner_radius", "get_emission_ring_inner_radius");
	ADD_SUBGROUP("Angle", "");
	ADD_PROPERTYI(PropertyInfo(Variant::FLOAT, "angle_min", PROPERTY_HINT_RANGE, "-720,720,0.1,or_less,or_greater,degrees"), "set_param_min", "get_param_min", PARAM_ANGLE);
	ADD_PROPERTYI(PropertyInfo(Variant::FLOAT, "angle_max", PROPERTY_HINT_RANGE, "-720,720,0.1,or_less,or_greater,degrees"), "set_param_max", "get_param_max", PARAM_ANGLE);
	ADD_PROPERTYI(PropertyInfo(Variant::OBJECT, "angle_curve", PROPERTY_HINT_RESOURCE_TYPE, "CurveTexture"), "set_param_texture", "get_param_texture", PARAM_ANGLE);
	ADD_SUBGROUP("Velocity", "");
	ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "inherit_velocity_ratio", PROPERTY_HINT_RANGE, "0.0,1.0,0.001,or_less,or_greater"), "set_inherit_velocity_ratio", "get_inherit_velocity_ratio");
	ADD_PROPERTY(PropertyInfo(Variant::VECTOR3, "velocity_pivot"), "set_velocity_pivot", "get_velocity_pivot");
	ADD_PROPERTY(PropertyInfo(Variant::VECTOR3, "direction"), "set_direction", "get_direction");
	ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "spread", PROPERTY_HINT_RANGE, "0,180,0.001"), "set_spread", "get_spread");
	ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "flatness", PROPERTY_HINT_RANGE, "0,1,0.001"), "set_flatness", "get_flatness");
	ADD_PROPERTYI(PropertyInfo(Variant::FLOAT, "initial_velocity_min", PROPERTY_HINT_RANGE, "0,1000,0.01,or_less,or_greater"), "set_param_min", "get_param_min", PARAM_INITIAL_LINEAR_VELOCITY);
	ADD_PROPERTYI(PropertyInfo(Variant::FLOAT, "initial_velocity_max", PROPERTY_HINT_RANGE, "0,1000,0.01,or_less,or_greater"), "set_param_max", "get_param_max", PARAM_INITIAL_LINEAR_VELOCITY);
	ADD_GROUP("Animated Velocity", "");
	ADD_SUBGROUP("Velocity Limit", "");
	ADD_SUBGROUP("Angular Velocity", "angular_");
	ADD_PROPERTYI(PropertyInfo(Variant::FLOAT, "angular_velocity_min", PROPERTY_HINT_RANGE, "-720,720,0.01,or_less,or_greater"), "set_param_min", "get_param_min", PARAM_ANGULAR_VELOCITY);
	ADD_PROPERTYI(PropertyInfo(Variant::FLOAT, "angular_velocity_max", PROPERTY_HINT_RANGE, "-720,720,0.01,or_less,or_greater"), "set_param_max", "get_param_max", PARAM_ANGULAR_VELOCITY);
	ADD_PROPERTYI(PropertyInfo(Variant::OBJECT, "angular_velocity_curve", PROPERTY_HINT_RESOURCE_TYPE, "CurveTexture"), "set_param_texture", "get_param_texture", PARAM_ANGULAR_VELOCITY);
	ADD_SUBGROUP("Directional Velocity", "directional_");
	ADD_PROPERTYI(PropertyInfo(Variant::FLOAT, "directional_velocity_min", PROPERTY_HINT_RANGE, "-720,720,0.01,or_less,or_greater"), "set_param_min", "get_param_min", PARAM_DIRECTIONAL_VELOCITY);
	ADD_PROPERTYI(PropertyInfo(Variant::FLOAT, "directional_velocity_max", PROPERTY_HINT_RANGE, "-720,720,0.01,or_less,or_greater"), "set_param_max", "get_param_max", PARAM_DIRECTIONAL_VELOCITY);
	ADD_PROPERTYI(PropertyInfo(Variant::OBJECT, "directional_velocity_curve", PROPERTY_HINT_RESOURCE_TYPE, "CurveXYZTexture"), "set_param_texture", "get_param_texture", PARAM_DIRECTIONAL_VELOCITY);
	ADD_SUBGROUP("Orbit Velocity", "orbit_");
	ADD_PROPERTYI(PropertyInfo(Variant::FLOAT, "orbit_velocity_min", PROPERTY_HINT_RANGE, "-2,2,0.001,or_less,or_greater"), "set_param_min", "get_param_min", PARAM_ORBIT_VELOCITY);
	ADD_PROPERTYI(PropertyInfo(Variant::FLOAT, "orbit_velocity_max", PROPERTY_HINT_RANGE, "-2,2,0.001,or_less,or_greater"), "set_param_max", "get_param_max", PARAM_ORBIT_VELOCITY);
	ADD_PROPERTYI(PropertyInfo(Variant::OBJECT, "orbit_velocity_curve", PROPERTY_HINT_RESOURCE_TYPE, "CurveTexture,CurveXYZTexture"), "set_param_texture", "get_param_texture", PARAM_ORBIT_VELOCITY);
	ADD_SUBGROUP("Radial Velocity", "radial_");
	ADD_PROPERTYI(PropertyInfo(Variant::FLOAT, "radial_velocity_min", PROPERTY_HINT_RANGE, "-1000,1000,0.01,or_less,or_greater"), "set_param_min", "get_param_min", PARAM_RADIAL_VELOCITY);
	ADD_PROPERTYI(PropertyInfo(Variant::FLOAT, "radial_velocity_max", PROPERTY_HINT_RANGE, "-1000,1000,0.01,or_less,or_greater"), "set_param_max", "get_param_max", PARAM_RADIAL_VELOCITY);
	ADD_PROPERTYI(PropertyInfo(Variant::OBJECT, "radial_velocity_curve", PROPERTY_HINT_RESOURCE_TYPE, "CurveTexture"), "set_param_texture", "get_param_texture", PARAM_RADIAL_VELOCITY);
	ADD_SUBGROUP("Velocity Limit", "");
	ADD_PROPERTY(PropertyInfo(Variant::OBJECT, "velocity_limit_curve", PROPERTY_HINT_RESOURCE_TYPE, "CurveTexture"), "set_velocity_limit_curve", "get_velocity_limit_curve");
	ADD_GROUP("Accelerations", "");
	ADD_SUBGROUP("Gravity", "");
	ADD_PROPERTY(PropertyInfo(Variant::VECTOR3, "gravity"), "set_gravity", "get_gravity");
	ADD_SUBGROUP("Linear Accel", "linear_");
	ADD_PROPERTYI(PropertyInfo(Variant::FLOAT, "linear_accel_min", PROPERTY_HINT_RANGE, "-100,100,0.01,or_less,or_greater"), "set_param_min", "get_param_min", PARAM_LINEAR_ACCEL);
	ADD_PROPERTYI(PropertyInfo(Variant::FLOAT, "linear_accel_max", PROPERTY_HINT_RANGE, "-100,100,0.01,or_less,or_greater"), "set_param_max", "get_param_max", PARAM_LINEAR_ACCEL);
	ADD_PROPERTYI(PropertyInfo(Variant::OBJECT, "linear_accel_curve", PROPERTY_HINT_RESOURCE_TYPE, "CurveTexture"), "set_param_texture", "get_param_texture", PARAM_LINEAR_ACCEL);
	ADD_SUBGROUP("Radial Accel", "radial_");
	ADD_PROPERTYI(PropertyInfo(Variant::FLOAT, "radial_accel_min", PROPERTY_HINT_RANGE, "-100,100,0.01,or_less,or_greater"), "set_param_min", "get_param_min", PARAM_RADIAL_ACCEL);
	ADD_PROPERTYI(PropertyInfo(Variant::FLOAT, "radial_accel_max", PROPERTY_HINT_RANGE, "-100,100,0.01,or_less,or_greater"), "set_param_max", "get_param_max", PARAM_RADIAL_ACCEL);
	ADD_PROPERTYI(PropertyInfo(Variant::OBJECT, "radial_accel_curve", PROPERTY_HINT_RESOURCE_TYPE, "CurveTexture"), "set_param_texture", "get_param_texture", PARAM_RADIAL_ACCEL);
	ADD_SUBGROUP("Tangential Accel", "tangential_");
	ADD_PROPERTYI(PropertyInfo(Variant::FLOAT, "tangential_accel_min", PROPERTY_HINT_RANGE, "-100,100,0.01,or_less,or_greater"), "set_param_min", "get_param_min", PARAM_TANGENTIAL_ACCEL);
	ADD_PROPERTYI(PropertyInfo(Variant::FLOAT, "tangential_accel_max", PROPERTY_HINT_RANGE, "-100,100,0.01,or_less,or_greater"), "set_param_max", "get_param_max", PARAM_TANGENTIAL_ACCEL);
	ADD_PROPERTYI(PropertyInfo(Variant::OBJECT, "tangential_accel_curve", PROPERTY_HINT_RESOURCE_TYPE, "CurveTexture"), "set_param_texture", "get_param_texture", PARAM_TANGENTIAL_ACCEL);
	ADD_SUBGROUP("Damping", "");
	ADD_PROPERTYI(PropertyInfo(Variant::FLOAT, "damping_min", PROPERTY_HINT_RANGE, "0,100,0.001,or_greater"), "set_param_min", "get_param_min", PARAM_DAMPING);
	ADD_PROPERTYI(PropertyInfo(Variant::FLOAT, "damping_max", PROPERTY_HINT_RANGE, "0,100,0.001,or_greater"), "set_param_max", "get_param_max", PARAM_DAMPING);
	ADD_PROPERTYI(PropertyInfo(Variant::OBJECT, "damping_curve", PROPERTY_HINT_RESOURCE_TYPE, "CurveTexture"), "set_param_texture", "get_param_texture", PARAM_DAMPING);
	ADD_SUBGROUP("Attractor Interaction", "attractor_interaction_");
	ADD_PROPERTY(PropertyInfo(Variant::BOOL, "attractor_interaction_enabled"), "set_attractor_interaction_enabled", "is_attractor_interaction_enabled");

	ADD_GROUP("Display", "");
	ADD_SUBGROUP("Scale", "");
	ADD_PROPERTYI(PropertyInfo(Variant::FLOAT, "scale_min", PROPERTY_HINT_RANGE, "0,1000,0.01,or_greater"), "set_param_min", "get_param_min", PARAM_SCALE);
	ADD_PROPERTYI(PropertyInfo(Variant::FLOAT, "scale_max", PROPERTY_HINT_RANGE, "0,1000,0.01,or_greater"), "set_param_max", "get_param_max", PARAM_SCALE);
	ADD_PROPERTYI(PropertyInfo(Variant::OBJECT, "scale_curve", PROPERTY_HINT_RESOURCE_TYPE, "CurveTexture,CurveXYZTexture"), "set_param_texture", "get_param_texture", PARAM_SCALE);
	ADD_SUBGROUP("Scale Over Velocity", "");
	ADD_PROPERTYI(PropertyInfo(Variant::FLOAT, "scale_over_velocity_min", PROPERTY_HINT_RANGE, "0,1000,0.01,or_greater"), "set_param_min", "get_param_min", PARAM_SCALE_OVER_VELOCITY);
	ADD_PROPERTYI(PropertyInfo(Variant::FLOAT, "scale_over_velocity_max", PROPERTY_HINT_RANGE, "0,1000,0.01,or_greater"), "set_param_max", "get_param_max", PARAM_SCALE_OVER_VELOCITY);
	ADD_PROPERTYI(PropertyInfo(Variant::OBJECT, "scale_over_velocity_curve", PROPERTY_HINT_RESOURCE_TYPE, "CurveTexture,CurveXYZTexture"), "set_param_texture", "get_param_texture", PARAM_SCALE_OVER_VELOCITY);

	ADD_SUBGROUP("Color Curves", "");
	ADD_PROPERTY(PropertyInfo(Variant::COLOR, "color"), "set_color", "get_color");
	ADD_PROPERTY(PropertyInfo(Variant::OBJECT, "color_ramp", PROPERTY_HINT_RESOURCE_TYPE, "GradientTexture1D"), "set_color_ramp", "get_color_ramp");
	ADD_PROPERTY(PropertyInfo(Variant::OBJECT, "color_initial_ramp", PROPERTY_HINT_RESOURCE_TYPE, "GradientTexture1D"), "set_color_initial_ramp", "get_color_initial_ramp");
	ADD_PROPERTY(PropertyInfo(Variant::OBJECT, "alpha_curve", PROPERTY_HINT_RESOURCE_TYPE, "CurveTexture"), "set_alpha_curve", "get_alpha_curve");
	ADD_PROPERTY(PropertyInfo(Variant::OBJECT, "emission_curve", PROPERTY_HINT_RESOURCE_TYPE, "CurveTexture"), "set_emission_curve", "get_emission_curve");
	ADD_SUBGROUP("Hue Variation", "hue_");
	ADD_PROPERTYI(PropertyInfo(Variant::FLOAT, "hue_variation_min", PROPERTY_HINT_RANGE, "-1,1,0.01"), "set_param_min", "get_param_min", PARAM_HUE_VARIATION);
	ADD_PROPERTYI(PropertyInfo(Variant::FLOAT, "hue_variation_max", PROPERTY_HINT_RANGE, "-1,1,0.01"), "set_param_max", "get_param_max", PARAM_HUE_VARIATION);
	ADD_PROPERTYI(PropertyInfo(Variant::OBJECT, "hue_variation_curve", PROPERTY_HINT_RESOURCE_TYPE, "CurveTexture"), "set_param_texture", "get_param_texture", PARAM_HUE_VARIATION);
	ADD_SUBGROUP("Animation", "anim_");
	ADD_PROPERTYI(PropertyInfo(Variant::FLOAT, "anim_speed_min", PROPERTY_HINT_RANGE, "0,16,0.01,or_less,or_greater"), "set_param_min", "get_param_min", PARAM_ANIM_SPEED);
	ADD_PROPERTYI(PropertyInfo(Variant::FLOAT, "anim_speed_max", PROPERTY_HINT_RANGE, "0,16,0.01,or_less,or_greater"), "set_param_max", "get_param_max", PARAM_ANIM_SPEED);
	ADD_PROPERTYI(PropertyInfo(Variant::OBJECT, "anim_speed_curve", PROPERTY_HINT_RESOURCE_TYPE, "CurveTexture"), "set_param_texture", "get_param_texture", PARAM_ANIM_SPEED);
	ADD_PROPERTYI(PropertyInfo(Variant::FLOAT, "anim_offset_min", PROPERTY_HINT_RANGE, "0,1,0.0001"), "set_param_min", "get_param_min", PARAM_ANIM_OFFSET);
	ADD_PROPERTYI(PropertyInfo(Variant::FLOAT, "anim_offset_max", PROPERTY_HINT_RANGE, "0,1,0.0001"), "set_param_max", "get_param_max", PARAM_ANIM_OFFSET);
	ADD_PROPERTYI(PropertyInfo(Variant::OBJECT, "anim_offset_curve", PROPERTY_HINT_RESOURCE_TYPE, "CurveTexture"), "set_param_texture", "get_param_texture", PARAM_ANIM_OFFSET);

	ADD_GROUP("Turbulence", "turbulence_");
	ADD_PROPERTY(PropertyInfo(Variant::BOOL, "turbulence_enabled"), "set_turbulence_enabled", "get_turbulence_enabled");
	ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "turbulence_noise_strength", PROPERTY_HINT_RANGE, "0,20,0.01"), "set_turbulence_noise_strength", "get_turbulence_noise_strength");
	ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "turbulence_noise_scale", PROPERTY_HINT_RANGE, "0,10,0.001,or_greater"), "set_turbulence_noise_scale", "get_turbulence_noise_scale");
	ADD_PROPERTY(PropertyInfo(Variant::VECTOR3, "turbulence_noise_speed"), "set_turbulence_noise_speed", "get_turbulence_noise_speed");
	ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "turbulence_noise_speed_random", PROPERTY_HINT_RANGE, "0,4,0.01"), "set_turbulence_noise_speed_random", "get_turbulence_noise_speed_random");
	ADD_PROPERTYI(PropertyInfo(Variant::FLOAT, "turbulence_influence_min", PROPERTY_HINT_RANGE, "0,1,0.001"), "set_param_min", "get_param_min", PARAM_TURB_VEL_INFLUENCE);
	ADD_PROPERTYI(PropertyInfo(Variant::FLOAT, "turbulence_influence_max", PROPERTY_HINT_RANGE, "0,1,0.001"), "set_param_max", "get_param_max", PARAM_TURB_VEL_INFLUENCE);
	ADD_PROPERTYI(PropertyInfo(Variant::FLOAT, "turbulence_initial_displacement_min", PROPERTY_HINT_RANGE, "-100,100,0.1"), "set_param_min", "get_param_min", PARAM_TURB_INIT_DISPLACEMENT);
	ADD_PROPERTYI(PropertyInfo(Variant::FLOAT, "turbulence_initial_displacement_max", PROPERTY_HINT_RANGE, "-100,100,0.1"), "set_param_max", "get_param_max", PARAM_TURB_INIT_DISPLACEMENT);
	ADD_PROPERTYI(PropertyInfo(Variant::OBJECT, "turbulence_influence_over_life", PROPERTY_HINT_RESOURCE_TYPE, "CurveTexture"), "set_param_texture", "get_param_texture", PARAM_TURB_INFLUENCE_OVER_LIFE);

	ADD_GROUP("Collision", "collision_");
	ADD_PROPERTY(PropertyInfo(Variant::INT, "collision_mode", PROPERTY_HINT_ENUM, "Disabled,Rigid,Hide On Contact"), "set_collision_mode", "get_collision_mode");
	ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "collision_friction", PROPERTY_HINT_RANGE, "0,1,0.01"), "set_collision_friction", "get_collision_friction");
	ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "collision_bounce", PROPERTY_HINT_RANGE, "0,1,0.01"), "set_collision_bounce", "get_collision_bounce");
	ADD_PROPERTY(PropertyInfo(Variant::BOOL, "collision_use_scale"), "set_collision_use_scale", "is_collision_using_scale");
"""
