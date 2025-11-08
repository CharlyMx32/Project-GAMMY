# scripts/actors/SlimeEnemy.gd
extends Enemy

func _ready():
	enemy_type = "slime"
	max_health = 30
	speed = 80
	damage = 5
	super._ready()
