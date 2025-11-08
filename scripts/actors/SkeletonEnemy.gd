# scripts/actors/SkeletonEnemy.gd  
extends Enemy

func _ready():
	enemy_type = "skeleton"
	max_health = 50
	speed = 100
	damage = 8
	super._ready()
