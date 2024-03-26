# Anime Homing Missile
This is a proof of concept of "anime" style homing missiles that follow the target in a wave like pattern. Made in Godot.

![anime-homing-missiles-overview](https://github.com/MarcusMakesGames/anime-homing-missile/assets/133889324/d27539f0-e9a7-435f-951d-aafece9f97ea)

# How does it work?
### Base Version
The most basic version of a homing missiles has to do these 2 things:

- fly forward
- rotate towards the aim point (center of the target)

With the correct values the homing missile will eventually reach the target and detonate.
 
![basic-homing-missile](https://github.com/MarcusMakesGames/anime-homing-missile/assets/133889324/39d9c5ce-6624-4408-8501-572de1f1bb00)

### Lateral Offset
To make the homing missile move in a more interesting way an offset needs to be calculated and added to the aim point position.

This offset is calculated like this:

- calculate the lateral direction between homing missile and target (direction from homing missile to target, rotated by 90°)
- calculate the lateral amplitude by using a sin function and the life time of the homing missile, this will create the wave like movement of the aim point
- take the lateral direction and multiply it with the lateral amplitude and a strength value (this strength value defines the max length of each "swing" of the aim point)

The aim point is now moving "up" and "down" and the homing missile will try to rotate itself towards this ever changing aim point.

![aim_point_lateral_offset_01](https://github.com/MarcusMakesGames/anime-homing-missile/assets/133889324/f0037432-ed82-4e06-be82-acea64f39061)

If the missile is now moving forward it will move in "waves" and gets closer to the target.

The problem: The smaller the distance between homing missile and target the stronger the wave motion gets.

In the worst case the missile won't hit the target.

To fix this the strength of the lateral amplitude needs to get weaker smaller the distance between homing missile and target gets.

![aim_point_lateral_offset_02](https://github.com/MarcusMakesGames/anime-homing-missile/assets/133889324/514bb08f-1c7c-4fe8-b8ce-bbd1faafd39a)

### Distance Based Lateral Amplitude
For the distance base strength calculation the homing missiles needs a couple of values:

- min distance between homing missile and target
- max distance between homing missile and target
- min lateral offset strength (the length the aim point moves in each direction)
- max lateral offset strength (the length the aim point moves in each direction)

To calculate the distance based strength with these values these calculation steps need to happen:

- calculate the current distance between homing missile and target
- calculate the current distance weight(0.0-1.0) by using inverse_lerp, current distance, min distance, and max distance
- clamp the current distance weight between 0.0 and 1.0
- calculate the current lateral offset strength by using lerpf, distance weight, min lateral strength, and max lateral strength

By doing this it creates a distance range in which the distance weight is kept between 0 and 1, even if the current distance is below the min distance or above the max distance. This allows for a finer control of the movement of the homing missile.

With the correct values the lateral offset of the aim point will get smaller the closer the homing missile gets.

![aim_point_lateral_offset_distance](https://github.com/MarcusMakesGames/anime-homing-missile/assets/133889324/5c7ab8de-0db8-4660-9a1e-6da9dcd08445)

The homing missile is now functional but it still has some strong motion even when close to the target.

By reducing the lateral offset strength this can be minimized, but this would also result in an overall less exciting motion.

To fix this another offset can be added to offset the aim point forward in front of the target.

![homing-missile-barrage-lateral-offset](https://github.com/MarcusMakesGames/anime-homing-missile/assets/133889324/21d3758c-5115-420b-84c5-c11a0dcb6044)

### Distance Forward Offset
The forward distance offset uses the same distance calculation the distance based lateral amplitude uses.

It just uses two new values to calculate the forward offset:

- min forward distance
- max forward distance

Combined with the lateral offset the homing missile now get a lot closer to the target during the approach.

![aim_point_forward_offset_01](https://github.com/MarcusMakesGames/anime-homing-missile/assets/133889324/efcfb148-79e5-4811-8f38-c2137f9ff619)

The homing missile is now fully functional.

![aim_point_forward_offset_02](https://github.com/MarcusMakesGames/anime-homing-missile/assets/133889324/aaeaff6d-c78d-4eef-bdf8-43e30ba31d5f)

### Recommendations
For moving targets it is recommended to not set the min lateral offset strength and min forward distance to 0.

In this example the min forward distance is set to 10 and the min lateral offset strength is also set to 10.

This way the homing missile also hit the target from the sides and fly next to the target for a brief moment before hitting it.

![final_homing_missile_barrage](https://github.com/MarcusMakesGames/anime-homing-missile/assets/133889324/1ca17193-95e0-4fdb-95b1-59b3d292e55e)

### Important Files
**scenes/sandbox.tscn** is the level to test out the homing missiles

**scripts/homing_missiles.tscn** is the script for the missiles
