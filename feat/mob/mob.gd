extends CharacterBody2D

signal mob_died(color)

@export var sucking_time_needed = 1.0
@export var speed = 80
@onready var player = get_node("/root/Main/Player")
var gun_area_timer = 0.0
var gun_area_entered = false

func _get_current_gun_color():
    return player.get_node("GunSprite").animation

func _physics_process(delta):
    if player != null:
        $AnimatedSprite2D.flip_h = player.position.x > position.x

    if player:
        position += (player.position - position) / speed

    scale = Vector2(1 - gun_area_timer / 10 * 2, 1 - gun_area_timer / 10 * 2)

    if gun_area_entered and _get_current_gun_color() == $AnimatedSprite2D.animation:
        gun_area_timer += delta

        if gun_area_timer >= sucking_time_needed:
            # $SuckSound.play()
            mob_died.emit($AnimatedSprite2D.animation)
            # hide()
            # await $SuckSound.finished()
            queue_free()

func _on_detection_area_area_entered(area: Area2D):
    if area.is_in_group("Gun"):
        gun_area_entered = true
        gun_area_timer = 0.0

func _on_detection_area_area_exited(area: Area2D):
    if area.is_in_group("Gun") and area.get_parent().animation == $AnimatedSprite2D.animation:
        gun_area_entered = false
        gun_area_timer = 0.0
