extends CharacterBody2D

signal mob_died

var speed = 100
var player_chase = false
var player = null
var gun_area_timer = 0.0
var gun_area_entered = false

func _physics_process(delta):
    if player_chase:
        position += (player.position - position) / speed
    scale = Vector2(1 - gun_area_timer / 10 * 2, 1 - gun_area_timer / 10 * 2)

    if gun_area_entered:
        gun_area_timer += delta

        if gun_area_timer >= 2.0:
            # $SuckSound.play()
            mob_died.emit()
            # hide()
            # await $SuckSound.finished()
            queue_free()

func _on_detection_area_area_entered(area: Area2D):
    if area.name == "Player":
        player = area
        player_chase = true

    if area.is_in_group("Gun") and area.get_parent().animation == $AnimatedSprite2D.animation:
        gun_area_entered = true
        gun_area_timer = 0.0
        print("is in lol")

func _on_detection_area_area_exited(area: Area2D):
    if area.is_in_group("Gun") and area.get_parent().animation == $AnimatedSprite2D.animation:
        gun_area_entered = false
        gun_area_timer = 0.0
