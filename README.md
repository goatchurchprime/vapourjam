# VapourJam

For https://itch.io/jam/godot-xr-game-jam
![coverpicture](https://github.com/goatchurchprime/vapourjam/assets/677254/54567781-32aa-42a4-9110-e26f8681db9a)

This has now been experimentally upgraded to to WebRTC multiplayer with added VOIP using the 
[multiplayer workbench](https://github.com/goatchurchprime/godot_multiplayer_networking_workbench).

## Addons required

* **Godot OpenXR Vendors plugin for Godot 4.3** Version: 3.0.0, installs into addons/godotopenxrvendors
* **WebRTC plugin - Godot 4.1+** Version: 1.0.6, !!install into addons/webrtc
* **TwoVoip** Version: v3.0 install into addons/twovoip
* **godotopenxr** (or [openxrvendors](https://github.com/GodotVR/godot_openxr_vendors))
* **NetworkingWorkbench** from [repo](https://github.com/goatchurchprime/godot_multiplayer_networking_workbench) (included)
* **Godot XR Tools** Version: 4.3.3, installs into addons/godot-xr-tools (included)
* **MQTT CLient** Version: 1.2 installs into addons/mqtt (included)
* **XR Input Simulator** Version: 1.2.0 installs into addons/xr-simulator

## Issues

I wanted to add a sandbox feature for editing all the parameters for the GPU particle emitters 
and colliders in the game, having heard that the Godot editor is itself a game.  
Unfortunately, all those parameter editing elements are 
[constructed by the C++ code](https://github.com/godotengine/godot/blob/master/scene/resources/particle_process_material.cpp#L2067) 
and so can't be redeployed from inside a Godot game quite so easily.

