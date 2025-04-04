extends RigidBody2D
# Direction in which the bullet moves
@export var speed = 5000
signal shot_enemy
signal shot_gold


func _ready() -> void:
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func fire(direction):
	apply_central_impulse(direction * speed)


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):  # Only detect enemies
		print("emiting shot enemy")
		shot_enemy.emit()
		
	elif body.is_in_group("reward"):
		print("emiting shot gold")
		shot_gold.emit()
		
