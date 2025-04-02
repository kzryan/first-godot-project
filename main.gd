extends Node

@export var mob_scene: PackedScene
@export var reward_scene: PackedScene

var score = 0
var gold = 0
var level = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#new_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$RewardTimer.stop()
	level = 1
	gold = 0
	score = 0
	$HUD.show_game_over()

func new_game():
	$MobTimer.wait_time =0.5
	clearEnemies()
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$RewardTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	$HUD.show_message("Level 1")

func _on_mob_timer_timeout():
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()

	# Choose a random location on Path2D.
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Set the mob's position to a random location.
	mob.position = mob_spawn_location.position

	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)

func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()


func _on_reward_timer_timeout() -> void:
	# Create a new instance of the reward scene.
	var reward = reward_scene.instantiate()

	# Choose a random location on Path2D.
	var reward_spawn_location = $RewardPath/RewardSpawnLocation
	reward_spawn_location.progress_ratio = randf()


	# Set the reward's position to a random location.
	reward.position = reward_spawn_location.position

	# Spawn the mob by adding it to the Main scene.
	add_child(reward)

func _on_player_hit_gold() -> void:
	gold += 1
	$HUD.update_gold(gold)
	if gold >= 5:
		level_up()

func level_up() -> void:
	gold = 0
	level += 1
	$HUD.show_message("Level "+str(level))
	$MobTimer.wait_time *= 0.97
	clearEnemies()
	
func clearEnemies() -> void:
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.queue_free()
	for reward in get_tree().get_nodes_in_group("rewards"):
		reward.queue_free()


func _on_bullet_shot() -> void:
	pass # Replace with function body.
