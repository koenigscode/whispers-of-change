extends CharacterBody2D

var speed = 100
var player_chase = false
var player = null
@export var health = 3
var gun_area_timer = 0.0
var gun_area_entered = false

func _physics_process(delta):
    if player_chase:
        position += (player.position - position) / speed

    if gun_area_entered:
        gun_area_timer += delta
        if gun_area_timer >= 3.0:
            queue_free()

func _on_detection_area_area_entered(area: Area2D):
    if area.name == "Player":
        player = area
        player_chase = true

    if area.is_in_group("Gun"):
        gun_area_entered = true
        gun_area_timer = 0.0

func _on_detection_area_area_exited(area: Area2D):
    if area.is_in_group("Gun"):
        gun_area_entered = false
        gun_area_timer = 0.0