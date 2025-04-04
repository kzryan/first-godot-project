extends RigidBody2D
# Direction in which the bullet moves
@export var speed = 5000
signal shot_enemy
signal shot_gold

func _ready() -> void:
	var parent_node = get_parent()
	if parent_node:
		shot_enemy.connect(parent_node._on_shot_enemy)
		shot_gold.connect(parent_node._on_player_hit_gold)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func fire(direction):
	apply_central_impulse(direction * speed)


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):  # Only detect enemies
		shot_enemy.emit()
		body.queue_free()
		
	elif body.is_in_group("reward"):
		shot_gold.emit()
		body.queue_free()
		
