extends Node

@export var mob_scene: PackedScene
var score

var score_red
var score_green
var score_blue
var winning_message_shown = false

func _ready():
    pass

func game_over():
    $ScoreTimer.stop()
    $MobTimer.stop()
    $HUD.show_game_over()

func new_game():
    # remove all old mobs (from previous round)
    get_tree().call_group("mobs", "queue_free")

    $TileMap.material.set_shader_parameter("r_saturation", 0)
    $TileMap.material.set_shader_parameter("g_saturation", 0)
    $TileMap.material.set_shader_parameter("b_saturation", 0)

    score = 0
    score_red = 0
    score_green = 0
    score_blue = 0

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

func _on_mob_died(color):
    if (color == "red"):
        score_red += 1
        $TileMap.material.set_shader_parameter("r_saturation", score_red)
    elif (color == "green"):
        score_green += 1
        $TileMap.material.set_shader_parameter("g_saturation", score_green)
    elif (color == "blue"):
        score_blue += 1
        $TileMap.material.set_shader_parameter("b_saturation", score_blue)
    
    if score_red >= 10 and score_green >= 10 and score_blue >= 10 and winning_message_shown == false:
        $HUD.show_message("You restored the colors!")
        winning_message_shown = true

    if score == 50:
        $HUD.show_message("You're gonna burn your eyes! lmao")

    $DeathSound.play()
    score += 1
