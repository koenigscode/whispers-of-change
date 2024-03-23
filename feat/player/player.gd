extends Area2D

signal hit

@export var speed = 400
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready():
    hide()
    screen_size = get_viewport_rect().size
    $GunSprite.play()

func _get_velocity():
    var velocity = Vector2.ZERO
    if Input.is_action_pressed("move_right"):
        velocity.x += 1
    if Input.is_action_pressed("move_left"):
        velocity.x -= 1
    if Input.is_action_pressed("move_down"):
        velocity.y += 1
    if Input.is_action_pressed("move_up"):
        velocity.y -= 1

    if velocity.length() > 0:
        velocity = velocity.normalized() * speed
    
    return velocity

func _process(delta):
    var velocity = _get_velocity()
    var cursor_pos = get_global_mouse_position()
    var player_pos = global_position

    if velocity.length() > 0:
        $PlayerSprite.play()
    else:
        $PlayerSprite.stop()

    if velocity.x != 0:
        $PlayerSprite.animation = "walk"

    position += velocity * delta
    position = position.clamp(Vector2.ZERO, screen_size)

    # Flip sprites
    if cursor_pos.x > player_pos.x:
        scale.x = -1
    else:
        scale.x = 1

    $GunSprite.look_at(cursor_pos)
    $GunSprite.flip_h = true

func _on_body_entered(body: Node2D):
    print("player hit")
    hide() # Player disappears after being hit.
    hit.emit()
    # Must be deferred as we can't change physics properties on a physics callback.
    $CollisionShape2D.set_deferred("disabled", true)

func start(pos):
    position = pos
    show()
    $CollisionShape2D.disabled = false
