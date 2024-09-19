extends Node2D


# Ready function to set up the timer
func _ready():
	var timer = $EnemyAttackTimer
	timer.connect("timeout", self, "_on_enemy_attack_timeout")
	start_random_attack()

# Function to start the random timer
func start_random_attack():
	var timer = $EnemyAttackTimer
	timer.wait_time = randf_range(0.3, 1.3)  # Random time between 0.3 and 1.3 seconds
	timer.start()

# Function called when the timer times out
func _on_enemy_attack_timeout():
	enemy_attack()
	start_random_attack()  # Restart the timer with a new random interval

# This function reduces the ally's health
func enemy_attack():
	var damage = 10  # You can adjust the damage amount
	ally_health -= damage
	
	# Ensure the health doesn't drop below 0
	if ally_health < 0:
		ally_health = 0
	
	# Call a function to update the health bar (to be implemented in Step 5)
	update_ally_health_bar()
	
	# Optionally, check for game over state
	if ally_health == 0:
		game_over()
