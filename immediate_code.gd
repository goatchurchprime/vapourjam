@tool
extends EditorScript

# Shift-Ctrl-X to run
var noise: FastNoiseLite
var gradient: Gradient
var gradient_tex: GradientTexture1D

var heightmap_rid: RID
var gradient_rid: RID
var uniform_set: RID
var pipeline: RID


var po2_dimensions: int
var start_time: int
var heightmap_rect: TextureRect



func _run():
	print("hi there")
	var rd = RenderingServer.create_local_rendering_device()
	print(rd)
	var shader_file_data: RDShaderFile = load("compute_shader.glsl")
	print(shader_file_data)
	var shader_spirv: RDShaderSPIRV = shader_file_data.get_spirv()
	print(shader_spirv)
	var shader_rid = rd.shader_create_from_spirv(shader_spirv)
	print(shader_rid)
	
		# Create format for heightmap.
	var heightmap_format := RDTextureFormat.new()
	# There are a lot of different formats. It might take some studying to be able to be able to
	# choose the right ones. In this case, we tell it to interpret the data as a single byte for red.
	# Even though the noise image only has a luminance channel, we can just interpret this as if it
	# was the red channel. The byte layout is the same!
	heightmap_format.format = RenderingDevice.DATA_FORMAT_R8_UNORM
	heightmap_format.width = po2_dimensions
	heightmap_format.height = po2_dimensions
	# The TextureUsageBits are stored as 'bit fields', denoting what can be done with the data.
	# Because of how bit fields work, we can just sum the required ones: 8 + 64 + 128
	heightmap_format.usage_bits = \
			RenderingDevice.TEXTURE_USAGE_STORAGE_BIT + \
			RenderingDevice.TEXTURE_USAGE_CAN_UPDATE_BIT + \
			RenderingDevice.TEXTURE_USAGE_CAN_COPY_FROM_BIT

	# Prepare heightmap texture. We will set the data later.
	var heightmap_rid = rd.texture_create(heightmap_format, RDTextureView.new())

	# Create uniform for heightmap.
	var heightmap_uniform := RDUniform.new()
	heightmap_uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_IMAGE
	heightmap_uniform.binding = 0  # This matches the binding in the shader.
	heightmap_uniform.add_id(heightmap_rid)

	# Create format for the gradient.
	var gradient_format := RDTextureFormat.new()
	# The gradient could have been converted to a single channel like we did with the heightmap,
	# but for illustrative purposes, we use four channels (RGBA).
	gradient_format.format = RenderingDevice.DATA_FORMAT_R8G8B8A8_UNORM
	gradient_format.width = 256 # gradient_tex.width  # Default: 256
	# GradientTexture1D always has a height of 1.
	gradient_format.height = 1
	gradient_format.usage_bits = \
		RenderingDevice.TEXTURE_USAGE_STORAGE_BIT + \
		RenderingDevice.TEXTURE_USAGE_CAN_UPDATE_BIT

	# Storage gradient as texture.
	gradient_rid = rd.texture_create(gradient_format, RDTextureView.new(), [gradient_tex.get_image().get_data()])

	# Create uniform for gradient.
	var gradient_uniform := RDUniform.new()
	gradient_uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_IMAGE
	gradient_uniform.binding = 1  # This matches the binding in the shader.
	gradient_uniform.add_id(gradient_rid)

	uniform_set = rd.uniform_set_create([heightmap_uniform, gradient_uniform], shader_rid, 0)

	pipeline = rd.compute_pipeline_create(shader_rid)



	start_time = Time.get_ticks_usec()
	# Use the to_int() method on the String to convert to a valid seed.
	noise.seed = 1999
	# Create image from noise.
	var heightmap := noise.get_image(po2_dimensions, po2_dimensions, false, false)

	# Create ImageTexture to display original on screen.
	var clone = Image.new()
	clone.copy_from(heightmap)
	clone.resize(512, 512, Image.INTERPOLATE_NEAREST)
	var clone_tex := ImageTexture.create_from_image(clone)
	heightmap_rect.texture = clone_tex


	# Store heightmap as texture.
	rd.texture_update(heightmap_rid, 0, heightmap.get_data())

	var compute_list := rd.compute_list_begin()
	rd.compute_list_bind_compute_pipeline(compute_list, pipeline)
	rd.compute_list_bind_uniform_set(compute_list, uniform_set, 0)
	# This is where the magic happens! As our shader has a work group size of 8x8x1, we dispatch
	# one for every 8x8 block of pixels here. This ratio is highly tunable, and performance may vary.
	rd.compute_list_dispatch(compute_list, po2_dimensions / 8, po2_dimensions / 8, 1)
	rd.compute_list_end()

	rd.submit()
	# Wait for the GPU to finish.
	# Normally, you would do this after a few frames have passed so the compute shader can run in the background.
	rd.sync()

	# Retrieve processed data.
	var output_bytes := rd.texture_get_data(heightmap_rid, 0)
	# Even though the GPU was working on the image as if each byte represented the red channel,
	# we'll interpret the data as if it was the luminance channel.
	var island_img := Image.create_from_data(po2_dimensions, po2_dimensions, false, Image.FORMAT_L8, output_bytes)
	print(island_img)
