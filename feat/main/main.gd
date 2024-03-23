extends Node

@export var mob_scene: PackedScene
@export var mob_min_speed = 80.0
@export var mob_max_speed = 100.0

var score

func _ready():
    pass

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
    $HUD.show_message("Get Ready")

func _on_score_timer_timeout():
    score += 1
    $HUD.update_score(score)

func _on_start_timer_timeout():
    $MobTimer.start()
    $ScoreTimer.start()

func _on_mob_timer_timeout():
    var mob = mob_scene.instantiate()

    # Choose a random location on Path2D.
    var mob_spawn_location = $MobPath/MobSpawnLocation
    mob_spawn_location.progress_ratio = randf()

    # Set the mob's direction perpendicular to the path direction.
    var direction = mob_spawn_location.rotation + PI / 2

    # Set the mob's position to a random location.
    mob.position = mob_spawn_location.position

    # Add some randomness to the direction.
    direction += randf_range( - PI / 4, PI / 4)

    # Choose the velocity for the mob.
    var velocity = Vector2(randf_range(mob_min_speed, mob_max_speed), 0.0)
    mob.linear_velocity = velocity.rotated(direction)

    mob.get_node("AnimatedSprite2D").flip_h = mob.linear_velocity.x > 0

    # Spawn the mob by adding it to the Main scene.
    add_child(mob)
