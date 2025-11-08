# scripts/actors/Player.gd
extends Actor

@export_category("Player Settings")
@export var attack_damage: int = 10

@onready var camera = $Camera2D

func _ready():
	actor_name = "Player"
	placeholder_color = Color.BLUE
	placeholder_size = Vector2(12, 16)
	
	print("🔵 Player.tscn - Inicializando...")
	print("   Posición: ", position)
	print("   ¿Cámara?: ", camera != null)
	
	super._ready()
	
	if camera:
		camera.enabled = true
		print("   📷 Cámara activada")
	else:
		print("   ⚠️ NO hay cámara en Player.tscn")

func _physics_process(delta):
	handle_movement()
	handle_attack()

func handle_movement():
	var input_direction = Vector2.ZERO
	input_direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	if input_direction != Vector2.ZERO:
		print("   🎮 Input: ", input_direction)
	
	velocity = input_direction.normalized() * speed
	move_and_slide()
	
	if velocity != Vector2.ZERO:
		print("   🏃 Movimiento - Pos: ", position)

func handle_attack():
	if Input.is_action_just_pressed("attack"):
		print("🗡️ Jugador ataca!")

signal player_died

func die():
	print("💀 Jugador murió!")
	player_died.emit()
	super.die()
