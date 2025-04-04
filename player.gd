extends Area2D
signal hit
signal hit_gold
@export var bullet_scene: PackedScene
@export var speed = 300 # How fast the player will move (pixels/sec).
var screen_size # Size of the game windckedSceneow.
var shoot_direction = Vector2.RIGHT
var can_shoot = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = Vector2.ZERO  # Reset velocity each frame

	if Input.is_action_pressed("move_right"):
		velocity.x += 1
		shoot_direction = Vector2.RIGHT
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
		shoot_direction = Vector2.LEFT
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
		shoot_direction = Vector2.DOWN
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
		shoot_direction = Vector2.UP
	if Input.is_action_pressed("attack"):
		#attack
		# Spawn the bullet by adding it to the player scene
		if can_shoot :
			var bullet = bullet_scene.instantiate()
			add_sibling(bullet)
			bullet.position = position
			bullet.fire(shoot_direction)
			$CooldownTimer.start()
		can_shoot = false
		
		
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
		
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		# See the note below about the following boolean assignment.
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0
	

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):  # Only detect enemies
		hide()  # Player disappears after being hit.
		hit.emit()
		$CollisionShape2D.set_deferred("disabled", true)
	elif body.is_in_group("reward"):
		body.queue_free()
		hit_gold.emit()
	
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

	


func _on_cooldown_timer_timeout() -> void:
	can_shoot = true
