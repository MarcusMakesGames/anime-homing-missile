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

The problem: The smaller the distance between homing missile and target get the stronger the wave motion gets.

In the worst case the missile won't hit the target.

To fix this the strength of the lateral amplitude needs to get weaker smaller the distance between homing missile and target gets.

![aim_point_lateral_offset_02](https://github.com/MarcusMakesGames/anime-homing-missile/assets/133889324/514bb08f-1c7c-4fe8-b8ce-bbd1faafd39a)

### Distance Based Lateral Amplitude
To calculate a distance base strength for the lateral amplitude, the homing missiles needs a couple of values:

- min distance between homing missile and target
- max distance between homing missile and target
- min lateral offset strength (the length the aim point moves in each direction)
- max laterla offset strength (the length the aim point moves in each direction)



![aim_point_lateral_offset_distance](https://github.com/MarcusMakesGames/anime-homing-missile/assets/133889324/5c7ab8de-0db8-4660-9a1e-6da9dcd08445)

