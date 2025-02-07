extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var spawnPosition

var maxHealth = 100
var health:float = maxHealth
var lives = 3

var isAlive = true


func _ready() -> void:
	spawnPosition = position
	Eventbus.onCollide.connect(takeDamage)
	updateHealthUI()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	if (health <= 0):
		if isAlive:
			die()
	
	move_and_slide()

func die():
	health = 0
	isAlive = false
	lives -= 1
	print("health: " + str(health))
	print("dead")
	respawn()

func takeDamage():
	if isAlive:
		health -= 25
		updateHealthUI()
		print("Health: " + str(health))

func respawn():
	if lives > 0:
		health = maxHealth
		updateHealthUI()
		isAlive = true
		position = spawnPosition
	elif lives <= 0:
		get_tree().change_scene_to_file.bind("res://Scenes/game_over.tscn").call_deferred()
	
func updateHealthUI():
	$CanvasLayer/Control/Healthbar.value = health
	$CanvasLayer/Control/Lives.text = "Lives: " + str(lives)
