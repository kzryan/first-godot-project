extends RigidBody2D
# Direction in which the bullet moves
@export var speed = 5000


func _ready() -> void:
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func fire(direction):
	apply_central_impulse(direction * speed)


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_body_entered(body: Node) -> void:
	print("hit")
