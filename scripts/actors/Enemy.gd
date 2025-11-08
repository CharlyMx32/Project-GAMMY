# scripts/actors/Enemy.gd
class_name Enemy
extends Actor

@export_category("Enemy Settings")
@export var enemy_type: String = "Basic"
@export var damage: int = 5
@export var attack_cooldown: float = 1.0

var player_ref: Node2D
var can_attack: bool = true

func _ready():
	actor_name = "Enemy_" + enemy_type
	setup_enemy_color()
	super._ready()

func setup_enemy_color():
	match enemy_type:
		"slime":
			placeholder_color = Color.GREEN
		"skeleton":
			placeholder_color = Color.LIGHT_GRAY
		"bat":
			placeholder_color = Color.DARK_GRAY
		"boss":
			placeholder_color = Color.RED
			placeholder_size = Vector2(24, 24)
		_:
			placeholder_color = Color.PURPLE

func _physics_process(delta):
	if player_ref:
		chase_player(delta)

func chase_player(delta):
	var direction = (player_ref.global_position - global_position).normalized()
	velocity = direction * speed
	move_and_slide()

func set_player_target(player: Node2D):
	player_ref = player

func _on_attack_cooldown_timeout():
	can_attack = true
