# GravityGun
 
Just random 3D stuff made in godot with first-person camera, sometimes badly coded.

**Features:**
- **Gravity Gun** - pull and throw objects.
- **Backward Objects** - Rigid bodies that save their past states.
- **Rewind** - pressing Rewind button make all **Backward Objects** go back in time, mechanic inspired by Recall from Zelda: Tears of the Kingdom. Sometimes strange and fast rotations occur, can be solved with lerp_angle().
- **Grenade** - throw grenade in front of you, pushes objects in radius and affects terrain.
- **Auto Landscape Optimization** - each grenade creates new object to subtract from terrain, this feature solves stutters after several grenade throws by optimizing landscape after every third subtraction object created.
- **Rideable Car** - press LMB to enter and Esc to leave.
- **Radar** - shows nearby rigid bodies.
- **Top-down camera** - firstly I wanted to make something similar to map without PNGs but result kinda awkward.
