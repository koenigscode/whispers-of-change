extends Node

@export var mob_scene: PackedScene
var score

func _ready():
	$HUD/StartButton.hide()
	$HUD/ScoreLabel.hide()
	await $HUD.show_message_typewriter("In the soul world where everything is\n black and white, the ghosts were tired \nof the same old dullness. So, they decided \nto invade the human world \nto steal all the colors.", 1)
	await $HUD.show_message_typewriter("You are armed with special vacuum\n cleaners, used to suck in ghosts to \nbring their stolen colors back to the \nhuman world, making it \ncolorful and lively again.", 2)
	await $HUD.show_message_typewriter("Use R, G and B or 1, 2 and 3 to \nchange between your vacuum cleaners.\n The red vacuum cleaner can only suck\n in the red ghosts.The blue vacuum\n cleaner is only helpful with the blue ghosts.", 3)
	await $HUD.show_message_typewriter("The green one only deals with the\n green ghosts. Get close enough to the\n ghosts so that your vacuum cleaner\n can suck them in, controlling\n the movement with WASD.", 4)
	$HUD/StartButton.show()
	$HUD/ScoreLabel.show()
	

	

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()

func new_game():
	# remove all old mobs (from previous round)
	get_tree().call_group("mobs", "queue_free")

	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get ready to suck it!")

func _on_score_timer_timeout():
	# score += 1
	$HUD.update_score(score)

func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

func _on_mob_timer_timeout():
	var mob = mob_scene.instantiate()

	mob.connect("mob_died", self._on_mob_died)
	
	var types = mob.get_node("AnimatedSprite2D").sprite_frames.get_animation_names()
	mob.get_node("AnimatedSprite2D").play(types[randi() % types.size()])

	# Choose a random location on Path2D.
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Set the mob's position to a random location.
	mob.position = mob_spawn_location.position

	# Add some randomness to the direction.
	direction += randf_range( - PI / 4, PI / 4)

	#if (direction < 0):
		#mob.flip_h()
		#print("moving right?")

	# Choose the velocity for the mob.
	#var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	#mob.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)

func _on_mob_died():
	$DeathSound.play()
	score += 1
