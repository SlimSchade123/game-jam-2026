extends Node

signal enemy_collided(info: enemy_collision_info)
signal enemy_killed(target: Enemy2)
signal max_speed_changed(max_speed: float)


var enemies_spawned : int = 0

func new_enemy():
	enemies_spawned += 1

func bucket():
	enemy_collided.emit()
	max_speed_changed.emit()
	enemy_killed.emit()
