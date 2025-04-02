extends RigidBody2D


# Direction in which the bullet moves
var direction = Vector2.RIGHT
@export var speed = 5000
signal shot


func _ready() -> void:
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func fire(direction):
	apply_central_impulse(direction * speed)


func _on_body_entered(body: Node2D) -> void:
	print("BULLET HIT")
	if body.is_in_group("enemies"):  # Only detect enemies
		print("hit enemy")
		shot.emit()
		body.queue_free()
		$CollisionShape2D.set_deferred("disabled", true)
	else:
		pass
		
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
