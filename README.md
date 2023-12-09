# VapourJam

For https://itch.io/jam/godot-xr-game-jam
![coverpicture](https://github.com/goatchurchprime/vapourjam/assets/677254/54567781-32aa-42a4-9110-e26f8681db9a)

## Addons required

* godotopenxr (or [openxrvendors](https://github.com/GodotVR/godot_openxr_vendors))
* godot-xr-tools (included)
* xr-simulator (included)

## Issues

I wanted to add a sandbox feature for editing all the parameters for the GPU particle emitters 
and colliders in the game, having heard that the Godot editor is itself a game.  
Unfortunately, all those parameter editing elements are [constructed by the C++ code](https://github.com/godotengine/godot/blob/master/scene/resources/particle_process_material.cpp#L2067) and so can't be redeployed from inside a Godot game quite so easily.

