# VapourJam

For https://itch.io/jam/godot-xr-game-jam
![coverpicture](https://github.com/goatchurchprime/vapourjam/assets/677254/54567781-32aa-42a4-9110-e26f8681db9a)

This has now been experimentally upgraded to to WebRTC multiplayer with added VOIP using the 
[multiplayer workbench](https://github.com/goatchurchprime/godot_multiplayer_networking_workbench).

## Addons required

* [mqtt-client](https://godotengine.org/asset-library/asset/1993) v1.2 is already included because it is very small and pure GDScript
* **player-networking** from [repo](https://github.com/goatchurchprime/godot_multiplayer_networking_workbench) (included)
* **Godot OpenXR Vendors plugin for Godot 4.3** Version: 3.0.0, installs into addons/godotopenxrvendors
* [TwoVoip](https://godotengine.org/asset-library/asset/3169) v3.6 is required to compress your audio stream from the microphone using the Opus library.  It can be used on its own for testing from [two-voip-godot-4](https://github.com/goatchurchprime/two-voip-godot-4)  The asset is 100Mb, so is not included with the project.  **A version of the Godot Engine compiled with [Pull Request#100508](https://github.com/godotengine/godot/pull/100508) is recommended for a more reliable implementation of the microphone input.**
* [WebRTC plugin - Godot 4.1+](https://godotengine.org/asset-library/asset/2103) is required to implement the WebRTC protocol and is also about 100Mb in size (because it has the implementation for all platforms).  Make sure you set its download directory to `addons/webrtc`. 
* **godotopenxr** (or [openxrvendors](https://github.com/GodotVR/godot_openxr_vendors))
* **Godot XR Tools** Version: 4.3.3, installs into addons/godot-xr-tools (included)
* **XR Input Simulator** Version: 1.2.0 installs into addons/xr-simulator

## Issues

I wanted to add a sandbox feature for editing all the parameters for the GPU particle emitters 
and colliders in the game, having heard that the Godot editor is itself a game.  
Unfortunately, all those parameter editing elements are 
[constructed by the C++ code](https://github.com/godotengine/godot/blob/master/scene/resources/particle_process_material.cpp#L2067) 
and so can't be redeployed from inside a Godot game quite so easily.

