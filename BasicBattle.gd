extends Node2D

# Define health variables
#obvious placeholder variables
var ally_bar
var enemy_bar
var ally_health: int = 100
var enemy_health: int = 100
var max_ally_health: int = 100
var max_enemy_health: int = 100

#define attack variables
var enTimer: Timer
var alTimer: Timer
var canAttack: bool = true


# Ready function to set up the timer
func _ready():
	connect_interface()
	start_enemy_attack()
	update_ally_health_bar()
	update_enemy_health_bar()

func connect_interface():
	ally_bar = $CanvasLayer/Control/HPBar
	enemy_bar = $CanvasLayer/Control/EnemyHPBar
	enTimer = $EnemyCD
	alTimer = $AllyCD
	enTimer.connect("timeout", Callable(self, "_on_enemy_attack_timeout"))
	alTimer.connect("timeout", Callable(self, "_on_ally_attack_ready"))
	$CanvasLayer/Control/GridContainer/Move1.connect("pressed", Callable(self, "ally_attack").bind(1))
	$CanvasLayer/Control/GridContainer/Move2.connect("pressed", Callable(self, "ally_attack").bind(2))
	$CanvasLayer/Control/GridContainer/Move3.connect("pressed", Callable(self, "ally_attack").bind(3))
	$CanvasLayer/Control/GridContainer/Move4.connect("pressed", Callable(self, "ally_attack").bind(4))
	

# Function to start the enemy timer
func start_enemy_attack():
	enTimer.wait_time = randf_range(0.3, 1.3)  # Random time between 0.3 and 1.3 seconds
	enTimer.start()

# Function called when the timer times out
func _on_enemy_attack_timeout():
	enemy_attack()
	start_enemy_attack()  # Restart the timer with a new random interval
	
func _on_ally_attack_ready():
	canAttack = true

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


func ally_attack(move_number: int):
	if (canAttack):
		match move_number:
			1:
				# Move 1 logic
				print("Move 1 used")
			2:
				# Move 2 logic
				print("Move 2 used")
			3:
				# Move 3 logic
				print("Move 3 used")
			4:
				# Move 4 logic
				print("Move 4 used")
			_:
				# Default case if move_number is not 1-4
				print("Invalid move")

		# All moves reduce enemy health by 15 (this will be expanded to use data later)
		var damage = 15
		enemy_health -= damage

		# Start the wait time on the AllyCD timer (Cooldown Timer)
		alTimer.wait_time = 0.5  # 0.5 seconds
		alTimer.start()
		canAttack = false

		# Ensure enemy health doesn't drop below 0
		if enemy_health <= 0:
			enemy_health = 0
			game_over()

		# Call a function to update the enemy health bar (to be implemented in Step 5)
		update_enemy_health_bar()

func game_over():
	#should do something real, but I'm tired.
	
	#Disable further actions
	disable_controls()
	stop_timers()
	
func disable_controls():
	# Disable all Move buttons
	$Move1.disabled = true
	$Move2.disabled = true
	$Move3.disabled = true
	$Move4.disabled = true
	$Run.disabled = true
	
func stop_timers():
	if enTimer.is_running():
		enTimer.stop()
	if alTimer.is_running():
		alTimer.stop()

	
func update_ally_health_bar():
	# Calculate the ally's health percentage
	var health_percentage = float(ally_health) / max_ally_health * 100
	
	# Update the progress bar's value
	ally_bar.value = health_percentage
	
func update_enemy_health_bar():
	# Calculate the enemy's health percentage
	var health_percentage = float(enemy_health) / max_enemy_health * 100
	
	# Update the progress bar's value
	enemy_bar.value = health_percentage

